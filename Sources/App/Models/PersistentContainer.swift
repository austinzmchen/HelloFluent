//
//  PersistentContainer.swift
//  HelloFluent
//
//  Created by Austin Chen on 2017-07-05.
//

import Foundation
import PostgreSQLDriver
import PostgreSQL
import Fluent

class PersistentContainer {
    static let shared = PersistentContainer()
    
    func configure() {
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
    }
}
