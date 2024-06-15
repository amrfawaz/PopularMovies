//
//  MovieDetailsService.swift
//  
//
//  Created by AmrFawaz on 15/06/2024.
//

import Foundation
import Networking

protocol MovieDetailsService {
    func fetchMovieDetails() async -> Result<MovieDetails, Error>
}

public final class DefaultMovieDetailsService: MovieDetailsService {
    private let movieID: Int

    public init(movieID: Int) {
        self.movieID = movieID
    }

    func fetchMovieDetails() async -> Result<MovieDetails, Error> {
         let fetchPopularMoviesRequest = MovieDetailsRequest(movieID: movieID)

        guard let request = fetchPopularMoviesRequest.request else { return .failure(NetworkError.invalidRequest) }

        let network = NetworkManager()

        do {
            let results = try await network.request(request: request, of: MovieDetails.self)
            return .success(results)
        } catch {
            return .failure(error)
        }
    }
}

class MockMovieDetailsService: MovieDetailsService {
    var shouldReturnError = false
    var movieDetails: MovieDetails?

    func fetchMovieDetails() async -> Result<MovieDetails, Error> {
        if shouldReturnError {
            return .failure(NetworkError.noData)
        } else if let movieDetails = movieDetails {
            return .success(movieDetails)
        } else {
            return .failure(NetworkError.noData)
        }
    }
}
