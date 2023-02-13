//
//  MoviesEndpoint.swift
//  Beer
//
//  Created by jc.kim on 2/13/23.
//

import Foundation

enum MoviesEndpoint {
    case topRated
    case movieDetail(id: Int)
    case search(query: String)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        case .search:
            return "/3/search/movie"
        }
    }

    var method: HttpMethod {
        switch self {
        case .topRated, .movieDetail, .search:
            return .get
        }
    }

    var header: [String: String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWRkYmFmNTI2M2I1Yjc2MDdkNTMyODVmZWM1MDNjMCIsInN1YiI6IjYzZTk3ZDAyNjNhYWQyMDBhMTRjZTExYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.59Q8s9i6484U8W2h0M7e8ZmOye6yLMAmJ2-6KltKFhE"
        switch self {
        case .topRated, .movieDetail, .search:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .topRated, .movieDetail, .search:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(query: let query):
            return [
                URLQueryItem(name: "api_key", value: "8eddbaf5263b5b7607d53285fec503c0"),
                URLQueryItem(name: "query", value: query)
            ]
        case .topRated, .movieDetail:
            return []
        }
    }
}
