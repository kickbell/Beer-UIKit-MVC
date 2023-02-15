//
//  App.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import Foundation

//struct App: Decodable, Hashable {
//    let id: Int
//    let tagline: String
//    let name: String
//    let subheading: String
//    let image: String
//    let iap: Bool
//}

//enum Item: Decodable, Hashable {
//    case topRated(Movie)
//    case popular(Movie)
//    case genre(Genre)
//}

struct Item: Hashable {
    let topRated: Movie?
    let popular: Movie?
    let genre: Genre?
    let upcoming: Movie?
    
    init(topRated: Movie? = nil, popular: Movie? = nil, genre: Genre? = nil, upcoming: Movie? = nil) {
        self.topRated = topRated
        self.popular = popular
        self.genre = genre
        self.upcoming = upcoming
    }
    
    private let identifier = UUID()
}
