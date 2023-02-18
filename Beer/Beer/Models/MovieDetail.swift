//
//  MovieDetail.swift
//  Beer
//
//  Created by jc.kim on 2/15/23.
//

import Foundation

struct MovieDetail: Codable, Hashable {
//    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
//    let id: Int
//    let originalLanguage: String
//    let originalTitle: String
    let overview: String
////    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
//    let video: Bool
    let voteAverage: Double
//    let voteCount: Int
    let runtime: Int?
//    let revenue: Int
//    let status: String
    let tagline: String?
    
    enum CodingKeys: String, CodingKey {
//        case adult
        case overview
//        case popularity
//        case id
        case title
//        case video
        case backdropPath = "backdrop_path"
        case genres
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
        case runtime
//        case revenue
//        case status
        case tagline
    }
}
