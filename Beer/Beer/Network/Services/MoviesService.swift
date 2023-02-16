//
//  MoviesService.swift
//  Beer
//
//  Created by jc.kim on 2/13/23.
//

import Foundation

protocol MoviesServiceable {
    func popular() async -> Result<PopularMovieResult, RequestError>
    func topRated() async -> Result<TopRatedResult, RequestError>
    func upcoming() async -> Result<UpcomingMovieResult, RequestError>
    func genre() async -> Result<GenreMovieResult, RequestError>
    func search(query: String, page: Int) async -> Result<SearchMovieResult, RequestError>
    func detail(id: Int) async -> Result<MovieDetail, RequestError>
    func trending() async -> Result<TrendingMovieResult, RequestError>
}

struct MoviesService: HTTPClient, MoviesServiceable {
    func popular() async -> Result<PopularMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.popular, responseModel: PopularMovieResult.self)
    }
    
    func topRated() async -> Result<TopRatedResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: TopRatedResult.self)
    }
    
    func upcoming() async -> Result<UpcomingMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.upcomming, responseModel: UpcomingMovieResult.self)
    }
    
    func genre() async -> Result<GenreMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.genre, responseModel: GenreMovieResult.self)
    }

    func search(query: String, page: Int) async -> Result<SearchMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.search(query: query, page: page), responseModel: SearchMovieResult.self)
    }
    
    func detail(id: Int) async -> Result<MovieDetail, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieDetail(id: id), responseModel: MovieDetail.self)
    }
    
    func trending() async -> Result<TrendingMovieResult, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.trending, responseModel: TrendingMovieResult.self)
    }
}
