//
//  Endpoint.swift
//  Beer
//
//  Created by jc.kim on 2/10/23.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.punkapi.com"
        components.path = "/v2/beers" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

extension Endpoint {
    static var random: Self {
        Endpoint(path: "/random")
    }
    
    static func single(withID id: Int) -> Self {
        Endpoint(path: "/\(id)")
    }
    
    static func search(for page: Int = 1,
                       maxResultCount: Int = 80) -> Self {
        Endpoint(
            path: "",
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "80")
            ]
        )
    }
}
