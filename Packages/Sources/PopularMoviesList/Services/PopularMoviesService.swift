//
//  PopularMoviesService.swift
//
//
//  Created by AmrFawaz on 14/06/2024.
//

import Foundation
import Networking

protocol PopularMoviesService {
    func fetchPopularMovies() async -> Result<[Movie], Error>
    func canFetechNextPage() -> Bool
}

public final class DefaultPopularMoviesService: PopularMoviesService {
    public init() {}
    
    private lazy var response = FetchPopularMoviesResponse(
        page: 0,
        movies: [],
        totalPages: 0
    )
    
    private var nextPage: String {
        return "\(response.page + 1)"
    }
    
    func canFetechNextPage() -> Bool {
        return (response.page == 0 && response.totalPages == 0) ||  response.totalPages > response.page
    }
    
    func fetchPopularMovies() async -> Result<[Movie], Error> {
        var fetchPopularMoviesRequest = FetchPopularMoviesRequest()
        guard let url = fetchPopularMoviesRequest.request?.url else { return .failure(NetworkError.invalidURL) }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        fetchPopularMoviesRequest.params["page"] = nextPage
        components?.queryItems = fetchPopularMoviesRequest.params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let request = fetchPopularMoviesRequest.request else { return .failure(NetworkError.invalidRequest) }
        
        let network = NetworkManager()
        
        do {
            let results = try await network.request(request: request, of: FetchPopularMoviesResponse.self)
            response = results
            return .success(results.movies)
        } catch {
            return .failure(error)
        }
    }
}
