import Foundation

// kitura
import Kitura
import HeliumLogger

HeliumLogger.use() // allow Kitura's internal logs to show

let router = Router()
router.get("/") { (request, response, next) in
    let pet = Pet(name: "Naomi", age: 2)
    try pet.save()
    response.send("Hello Fluent!")
}

PersistentContainer.shared.configure()
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()

