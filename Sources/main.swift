import Foundation

// vapor sphere
import PostgreSQLDriver
import Fluent
import PostgreSQL

// kitura
import Kitura
import HeliumLogger


class Pet: Entity {
    var name: String
    var age: Int
    let storage = Storage()
    
    required init(row: Row) throws {
        name = try row.get("name")
        age = try row.get("age")
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("age", age)
        return row
    }
}

extension Pet: Preparation {
    static func prepare(_ database: Fluent.Database) throws {
        try database.create(self) { pets in
            pets.id()
            pets.string("name")
            pets.int("age")
        }
    }
    
    static func revert(_ database: Fluent.Database) throws {
        try database.delete(self)
    }
}

do {
    let postgreSQL = try PostgreSQL.Database(
        hostname: "localhost",
        database: "austinchen",
        user: "austinchen",
        password: ""
    )

    let driver = PostgreSQLDriver.Driver(master: postgreSQL)
    Fluent.Database.default = Fluent.Database(driver)
    try Fluent.Database.default?.prepare([Pet.self])
} catch {
    print(error.localizedDescription)
}

HeliumLogger.use() // allow Kitura's internal logs to show

let router = Router()
router.get("/") { (request, response, next) in
    let pet = Pet(name: "Naomi", age: 2)
    try pet.save()
    response.send("Hello Fluent!")
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()

