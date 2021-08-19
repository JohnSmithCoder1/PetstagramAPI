//
//  UserAuthentication+server.swift
//  Application
//
//  Created by J S on 8/19/21.
//

import Foundation
import CredentialsHTTP
import SwiftKueryORM

extension UserAuthentication: TypeSafeHTTPBasic {
    public static func verifyPassword(username: String, password: String, callback: @escaping (UserAuthentication?) -> Void) {
        UserAuthentication.find(id: username) { userAuth, error in
            if let userAuth = userAuth, password == userAuth.password {
                callback(userAuth)
                
                return
            }
            
            callback(nil)
        }
    }
}
