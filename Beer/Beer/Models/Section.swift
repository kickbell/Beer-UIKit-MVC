//
//  Section.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import Foundation

//struct Section: Decodable, Hashable {
//    let id: Int
//    let type: String
//    let title: String
//    let subtitle: String
//    let items: [App]
//}
//
//extension Section {
//    enum AppType: String {
//        case mediumTable
//        case smallTable
//        case featured
//        case none
//    }
//
//    var appType: AppType {
//        return AppType(rawValue: self.type) ?? .none
//    }
//}


enum Section:Int, CaseIterable, CustomStringConvertible, Decodable, Hashable {
    case popular, topRated, upcoming, genre
    
    var description: String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "TopRated"
        case .upcoming: return "Upcoming"
        case .genre: return "Genre"
        }
    }
}




