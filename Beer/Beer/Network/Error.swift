//
//  Error.swift
//  Beer
//
//  Created by jc.kim on 2/11/23.
//

import Foundation

enum MainError: Error, CustomStringConvertible {
    case network(NetworkError)
    case openLink
    
    var description: String {
        "MainError.\(self)".localized(safe: "알 수 없는 오류입니다. 잠시 후 다시 시도해주세요.".localized)
    }
}

enum NetworkError: Int, Error {
  case badRequest = 400
  case notFound = 404
  case systemError = 500
  case endpointError = 503
  case timeout = 504
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(safe: String) -> String {
        let localizedValue = self.localized
        return localizedValue == self ? safe : localizedValue
    }
}
