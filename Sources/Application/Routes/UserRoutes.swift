//
//  UserRoutes.swift
//  Application
//
//  Created by J S on 8/16/21.
//

import Foundation
import Kitura

var users: [UserAuthentication] = []

func initializeUserRoutes(app: App) {
    app.router.get("/api/v1/user", handler: getUser)
    app.router.post("/api/v1/user", handler: addUser)
}

func getUser(query: UserParams, completion: @escaping (UserAuthentication?, RequestError?) -> Void) {
    guard let foundUser = users.first(where: { $0.id == query.id }), foundUser.password == query.password else {
        completion(nil, RequestError.unauthorized)
        
        return
    }
    
    completion(foundUser, nil)
}

func addUser(user: UserAuthentication, completion: @escaping (UserAuthentication?, RequestError?) -> Void) {
    users.append(user)
    completion(user, nil)
}
