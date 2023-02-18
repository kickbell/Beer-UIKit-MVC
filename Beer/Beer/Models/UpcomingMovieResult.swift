//
//  UpcomingMovieResult.swift
//  Beer
//
//  Created by jc.kim on 2/15/23.
//

import Foundation

struct UpcomingMovieResult: Decodable {
//    let page: Int
//    let totalPages: Int
//    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
//        case page
        case results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
    }
}
