//
//  PopularMoviesViewModel.swift
//
//
//  Created by AmrFawaz on 14/06/2024.
//

import Foundation

public final class PopularMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String = ""

    private let services: PopularMoviesService

    init(services: PopularMoviesService) {
        self.services = services
    }

    @MainActor
    func fetchPopularMovies() async -> Void {
        if services.canFetechNextPage() {
            let result = await services.fetchPopularMovies()

            switch result {
            case .success(let response):
                movies.append(contentsOf: response)
                break
            case .failure(let error):
                errorMessage = error.localizedDescription
                break
            }
        }
    }
}
