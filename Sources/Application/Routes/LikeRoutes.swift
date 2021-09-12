//
//  LikeRoutes.swift
//  Application
//
//  Created by J S on 8/23/21.
//

import Foundation
import Kitura

func initializeLikeRoutes(app: App) {
    app.router.post("/api/v1/likes", handler: addLike)
    app.router.delete("/api/v1/likes", handler: deleteLike)
}

func addLike(user: UserAuthentication, like: Like, completion: @escaping (Like?, RequestError?) -> Void) {
    var newLike = like
    
    if newLike.createdByUser != user.id {
        return completion(nil, RequestError.forbidden)
    }
    
    if newLike.id == nil {
        newLike.id = UUID()
    }
    
    newLike.save(completion)
}

func deleteLike(user: UserAuthentication, query: LikeParams, completion: @escaping (RequestError?) -> Void) {
    if query.createdByUser != user.id {
        return completion(RequestError.forbidden)
    }
    
    Like.findAll(matching: query) { foundLikes, error in
        guard let foundLike = foundLikes?.first else {
            return completion(error ?? .notFound)
        }
        
        guard let likeId = foundLike.id else {
            return completion(.ormInternalError)
        }
        
        Like.delete(id: likeId, completion)
    }
}
