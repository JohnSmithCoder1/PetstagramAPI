//
//  PostRoutes.swift
//  Application
//
//  Created by J S on 8/15/21.
//

import Foundation
import KituraContracts
import SwiftKuery

let iso8601Decoder: () -> BodyDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    return decoder
}

let iso8601Encoder: () -> BodyEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    
    return encoder
}

func initializePostRoutes(app: App) {
    app.router.get("/api/v1/posts", handler: getPosts)
    app.router.post("/api/v1/posts", handler: addPost)
    app.router.decoders[.json] = iso8601Decoder
    app.router.encoders[.json] = iso8601Encoder
}

func getPosts(user: UserAuthentication, completion: @escaping ([Post]?, RequestError?) -> Void) {
    let postTable: Table
    let likeTable: Table
    
    do {
        postTable = try Post.getTable()
        likeTable = try Like.getTable()
    } catch {
        completion(nil, .ormInternalError)
        
        return
    }
    
    guard
        let postIdColumn = postTable.columns.first(where: { $0.name == "id" }),
        let likePostIdColumn = likeTable.columns.first(where: { $0.name == "postId" }),
        let likeDateColumn = likeTable.columns.first(where: { $0.name == "createdAt" }),
        let likeUserIdColumn = likeTable.columns.first(where: { $0.name == "createdByUser" })
    else {
        completion(nil, .ormInternalError)
        
        return
    }
    
    var selectFields: [Column] = []
    selectFields.append(contentsOf: postTable.columns.filter({ $0.name != "likedDate" }))
    selectFields.append(likeDateColumn.as("likedDate"))
    
    let query = Select(selectFields, from: postTable).leftJoin(likeTable).on(likePostIdColumn == postIdColumn && likeUserIdColumn == user.id)
    Post.executeQuery(query: query, completion)
}

func addPost(user: UserAuthentication, post: Post, completion: @escaping (Post?, RequestError?) -> Void) {
    var newPost = post
    
    if newPost.createdByUser != user.id {
        return completion(nil, RequestError.forbidden)
    }
    
    if newPost.id == nil {
        newPost.id = UUID()
    }
    
    newPost.save(completion)
}
