//
//  ImageRoutes.swift
//  Application
//
//  Created by J S on 8/16/21.
//

import Foundation
import Kitura

func initializeImageRoutes(app: App) throws {
    let fileServer = try setupFileServer()
    app.router.get("/api/v1/images", middleware: fileServer)
}

private func setupFileServer() throws -> StaticFileServer {
    let cacheOptions = StaticFileServer.CacheOptions(maxAgeCacheControlHeader: 3600)
    let options = StaticFileServer.Options(cacheOptions: cacheOptions)
    let fileServer = StaticFileServer(path: "images", options: options)
    
    try FileManager.default.createDirectory(atPath: fileServer.absoluteRootPath, withIntermediateDirectories: true, attributes: nil)
    
    return fileServer
}
