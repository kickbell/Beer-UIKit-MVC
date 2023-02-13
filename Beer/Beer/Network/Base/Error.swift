//
//  Error.swift
//  Beer
//
//  Created by jc.kim on 2/11/23.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}

//enum MainError: Error, CustomStringConvertible {
//    case network(NetworkError)
//    case openLink
//
//    var description: String {
//        "MainError.\(self)".localized(safe: "알 수 없는 오류입니다. 잠시 후 다시 시도해주세요.".localized)
//    }
//
//    enum NetworkError: Int, Error, CustomStringConvertible {
//        case invalidPath
//        case badRequest = 400
//        case notFound = 404
//        case systemError = 500
//        case endpointError = 503
//        case timeout = 504
//
//        var description: String {
//            switch self {
//            case .invalidPath:
//                return "".localized
//            case .badRequest:
//                return "".localized
//            case .notFound:
//                return "".localized
//            case .systemError:
//                return "".localized
//            case .endpointError:
//                return "".localized
//            case .timeout:
//                return "".localized
//            }
//        }
//    }
//}
//
//
//
//extension String {
//    var localized: String {
//        NSLocalizedString(self, comment: "")
//    }
//
//    func localized(safe: String) -> String {
//        let localizedValue = self.localized
//        return localizedValue == self ? safe : localizedValue
//    }
//}
