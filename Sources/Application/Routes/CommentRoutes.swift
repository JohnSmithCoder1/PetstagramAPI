//
//  CommentRoutes.swift
//  Application
//
//  Created by J S on 8/24/21.
//

import Foundation
import Kitura

func initializeCommentRoutes(app: App) {
    app.router.post("/api/v1/comments", handler: addComment)
    app.router.get("/api/v1/comments", handler: getComments)
}

func addComment(user: UserAuthentication, comment: Comment, completion: @escaping (Comment?, RequestError) -> Void) {
    var newComment = comment
    
    if newComment.createdByUser != user.id {
        return completion(nil, RequestError.forbidden)
    }
    
    if newComment.id == nil {
        newComment.id = UUID()
    }
    
    newComment.save(completion)
}

func getComments(user: UserAuthentication, query: CommentParams?, completion: @escaping ([Comment]?, RequestError?) -> Void) {
    Comment.findAll(matching: query, completion)
}
