//
//  Endpoint.swift
//  Beer
//
//  Created by jc.kim on 2/10/23.
//

import Foundation


protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.themoviedb.org"
    }
}

//
//extension Endpoint {
//    var scheme: String {
//        return "https"
//    }
//
//    var host: String {
//        return "api.themoviedb.org"
//    }
//}
//
//
//struct ApiHelper {
//    static let baseURL = "https://api.punkapi.com/v2/beers"
//}
//
//enum ApiEndpoint {
//    case random
//    case single(id: Int)
//    case search(page: Int, maxResultCount: Int)
//
//    enum Method: String {
//        case GET
//        case POST
//        case PUT
//        case DELETE
//    }
//}
//
//extension ApiEndpoint {
//    var path: String {
//        switch self {
//        case .random:
//            return ApiHelper.baseURL + "/random"
//        case .single(let id):
//            return ApiHelper.baseURL + "/\(id)"
//        case .search(_, _):
//            return ApiHelper.baseURL
//        }
//    }
//
//    /// The method for the endpoint
//    var method: ApiEndpoint.Method {
//        switch self {
//        default:
//            return .GET
//        }
//    }
//
//    /// The URL parameters for the endpoint (in case it has any)
//    var parameters: [URLQueryItem]? {
//        switch self {
//        case .random:
//            return []
//        case .single(_):
//            return []
//        case .search(let page, let maxCount):
//            var queryItems = [URLQueryItem]()
//            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
//            queryItems.append(URLQueryItem(name: "per_page", value: "\(maxCount)"))
//            return queryItems
//        }
//    }
//}
//
//struct Endpoint {
//    var path: String
//    var queryItems: [URLQueryItem] = []
//
//    enum Method: String {
//        case GET
//        case POST
//        case PUT
//        case DELETE
//    }
//}
//
//extension Endpoint {
//    var url: URL {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.punkapi.com"
//        components.path = "/v2/beers" + path
//        components.queryItems = queryItems
//
//        guard let url = components.url else {
//            preconditionFailure(
//                "Invalid URL components: \(components)"
//            )
//        }
//
//        return url
//    }
//
//    var method: Endpoint.Method {
//        switch self {
//        default:
//            return .GET
//        }
//    }
//}
//
//extension Endpoint {
//    static var random: Self {
//        Endpoint(path: "/random")
//    }
//
//    static func single(withID id: Int) -> Self {
//        Endpoint(path: "/\(id)")
//    }
//
//    static func search(for page: Int = 1,
//                       maxResultCount: Int = 80) -> Self {
//        Endpoint(
//            path: "",
//            queryItems: [
//                URLQueryItem(name: "page", value: "\(page)"),
//                URLQueryItem(name: "per_page", value: "80")
//            ]
//        )
//    }
//}
