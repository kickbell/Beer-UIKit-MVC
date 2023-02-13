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
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        }
    }

    var method: HttpMethod {
        switch self {
        case .topRated, .movieDetail:
            return .get
        }
    }

    var header: [String: String]? {
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZWRkYmFmNTI2M2I1Yjc2MDdkNTMyODVmZWM1MDNjMCIsInN1YiI6IjYzZTk3ZDAyNjNhYWQyMDBhMTRjZTExYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.59Q8s9i6484U8W2h0M7e8ZmOye6yLMAmJ2-6KltKFhE"
        switch self {
        case .topRated, .movieDetail:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .topRated, .movieDetail:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
}
