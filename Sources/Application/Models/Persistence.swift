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

extension Post: Model { }
extension UserAuthentication: Model { }

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
        
        createTable(Post.self)
        createTable(UserAuthentication.self)
    }
    
    private static func createTable<T: Model>(_ Table: T.Type) {
        do {
            try Table.createTableSync()
        } catch let tableError {
            if let requestError = tableError as? RequestError,
               requestError.rawValue == RequestError.ormQueryError.rawValue {
                Log.info("Table \(Table.tableName) already exists")
            } else {
                Log.error("Database connection error: \(String(describing: tableError))")
            }
        }
    }
}
