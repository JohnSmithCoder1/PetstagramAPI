//
//  PostRoutes.swift
//  Application
//
//  Created by J S on 8/15/21.
//

import Foundation
import KituraContracts

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

func getPosts(completion: @escaping ([Post]?, RequestError?) -> Void) {
    Post.findAll(completion)
}

func addPost(post: Post, completion: @escaping (Post?, RequestError?) -> Void) {
    var newPost = post
    
    if newPost.id == nil {
        newPost.id = UUID()
    }
    
    newPost.save(completion)
}
