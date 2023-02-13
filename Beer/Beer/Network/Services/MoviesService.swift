//
//  MoviesService.swift
//  Beer
//
//  Created by jc.kim on 2/13/23.
//

import Foundation

protocol MoviesServiceable {
    func getTopRated() async -> Result<TopRated, RequestError>
    func getMovieDetail(id: Int) async -> Result<Movie, RequestError>
    func search(query: String) async -> Result<SearchMovieResult, RequestError>
}

struct MoviesService: HTTPClient, MoviesServiceable {
    func getTopRated() async -> Result<TopRated, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: TopRated.self)
    }
    
    func getMovieDetail(id: Int) async -> Result<Movie, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieDetail(id: id), responseModel: Movie.self)
    }
    
    func search(query: String) async -> Result<SearchMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.search(query: query), responseModel: SearchMovieResult.self)
    }
}
