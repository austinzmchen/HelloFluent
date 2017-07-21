import Foundation

import Kitura
import PerfectCrypto

import LoggerAPI
import HeliumLogger

import Credentials
import CredentialsHTTP

HeliumLogger.use() // allow Kitura's internal logs to show

// setup middleware
let jwtMiddleware = JWTMiddleware()

// Create logging middleware
class RequestLogger: RouterMiddleware {
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.info("\(request.method) request made for \(request.originalURL)")
        next()
    }
}

// Setup basic credentials middleware
let credentials = Credentials()
let users = ["username" : "password"]

let httpBasic = CredentialsHTTPBasic(verifyPassword: { userId, password, callback in
    if let storedPassword = users[userId], storedPassword == password {
        Log.info("\(userId) logged in")
        callback(UserProfile(id: userId, displayName: userId, provider: "HTTPBasic"))
    } else {
        Log.error("\(userId) login failed")
        callback(nil)
    }
})
credentials.register(plugin: httpBasic)


// Create a new router
let router = Router()

// Setup routes
router.all("/*", middleware: RequestLogger())
router.all("/login", middleware: credentials)
router.all("/pet", middleware: jwtMiddleware)
router.all("/secure", middleware: jwtMiddleware)

router.get("/") { (request, response, next) in
    response.send("Hello Fluent!")
}
router.post("/pet") { (request, response, next) in
    let pet = Pet(name: "Naomi", age: 2)
    try pet.save()
    response.send("Pet saved: \(pet.name)")
}
router.get("/login") { request, response, next in
    let jwtPayload: [String : Any] = [
        "issuer": "ac.hellofluent",
        "issuedAt": Date().timeIntervalSince1970,
        "expiration": Date().append(months: 1).timeIntervalSince1970
    ]
    guard let jwt = JWTCreator(payload: jwtPayload) else {
        response.send("couldn't create token\n")
        next()
        return
    }
    let privateKeyAsPem = try PEMKey(source: privateKey)
    let signedJWTToken = try jwt.sign(alg: .rs256, key: privateKeyAsPem)
    response.send(json: ["token": signedJWTToken])
    next()
}
router.get("/secure") { request, response, next in
    response.send(json: ["message": "Secure hello from Swift!"])
    next()
}

PersistentContainer.shared.configure()
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()

