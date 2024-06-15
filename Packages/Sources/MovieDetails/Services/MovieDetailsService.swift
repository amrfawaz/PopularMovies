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
         var fetchPopularMoviesRequest = MovieDetailsRequest(movieID: movieID)

        guard let url = fetchPopularMoviesRequest.request?.url else { return .failure(NetworkError.invalidURL) }

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
