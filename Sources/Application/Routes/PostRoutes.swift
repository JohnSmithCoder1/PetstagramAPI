//
//  PostRoutes.swift
//  Application
//
//  Created by J S on 8/15/21.
//

import Foundation
import KituraContracts

var posts: [Post] = [Post(id: UUID(), caption: "Test Post1", createdAt: Date(), createdBy: "UserName"),
                     Post(id: UUID(), caption: "Test Post2", createdAt: Date() - (60*60*4), createdBy: "Another User")]

func initializePostRoutes(app: App) {
    app.router.get("/api/v1/posts", handler: getPosts)
}

func getPosts(completion: @escaping ([Post]?, RequestError?) -> Void) {
    completion(posts, nil)
}
