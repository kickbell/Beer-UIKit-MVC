//
//  BeerAPI.swift
//  Beer
//
//  Created by jc.kim on 2/9/23.
//

import Foundation

protocol BeerAPI {
//    func getBeers(page: Int?) -> Result<[Beer], BeerNetworkError>
//    func getBeer(id: String) -> Result<[Beer], BeerNetworkError>
//    func getRandomBeer() -> Result<[Beer], BeerNetworkError>
}

enum BeerNetworkError: Error {
    case error(String)
    case defaultError
    
    var message: String? {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "잠시 후에 다시 시도해주세요."
        }
    }
}



