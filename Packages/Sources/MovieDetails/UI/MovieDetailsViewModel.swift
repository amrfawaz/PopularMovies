//
//  MovieDetailsViewModel.swift
//
//
//  Created by AmrFawaz on 15/06/2024.
//

import Foundation
import AppConfigurations

public final class MovieDetailsViewModel: ObservableObject {
    @Published private var movieDetails: MovieDetails?
    
    internal var services: MovieDetailsService?

    let movieID: Int

    public init(movieID: Int) {
        self.movieID = movieID
        self.services = DefaultMovieDetailsService(movieID: movieID)
    }

    var title: String {
        movieDetails?.title ?? ""
    }

    var posterImagePath: String {
        guard let path = movieDetails?.posterPath else { return "" }
        return AppConstants.moviePosterRoot.rawValue + path
    }

    var releaseDate: String {
        movieDetails?.releaseDate ?? ""
    }

    var genres: String {
        guard let genres = movieDetails?.genres, !genres.isEmpty else { return "" }
        return genres.map({ $0.name }).joined(separator: ", ")
    }

    var overview: String {
        guard let overview = movieDetails?.overview else { return "" }
        return overview
    }

    var duration: String {
        guard let totalMinutes = movieDetails?.runtime else { return "" }

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    var rating: String {
        guard let rating = movieDetails?.voteAverage else { return "" }
        return String(format: "%.2f %%", rating * 10)
    }
}

extension MovieDetailsViewModel {
    @MainActor
    func fetchMovieDetails() async -> Void {
        let result = await services?.fetchMovieDetails()

        switch result {
        case .success(let response):
            movieDetails = response
            break
        case .failure(let error):
            // Handle failed response.
            print("Fetch failed: \(error.localizedDescription)")
            break
        case .none:
            break
        }
    }
}

// MARK: - Mocks

#if DEBUG
extension MovieDetailsViewModel {
    public static var mockedViewModel: MovieDetailsViewModel {
        let viewModel = MovieDetailsViewModel(movieID: 0)
        viewModel.movieDetails = .mockedMovieDetails
        return viewModel
    }
}
#endif
