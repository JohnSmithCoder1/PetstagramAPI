//
//  Persistence.swift
//  Application
//
//  Created by J S on 8/19/21.
//

import Foundation
import SwiftKueryORM
import SwiftKueryPostgreSQL
import LoggerAPI

class Persistence {
    static func setUp() {
        let pool = PostgreSQLConnection.createPool(
            host: ProcessInfo.processInfo.environment["DBHOST"] ?? "localhost",
            port: 5432,
            options: [.databaseName("petstagram"),
                      .userName(ProcessInfo.processInfo.environment["DBUSER"] ?? "postgres"),
                      .password(ProcessInfo.processInfo.environment["DBPASSWORD"] ?? "nil")
            ],
            poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50)
        )
        
        Database.default = Database(pool)
    }
}
