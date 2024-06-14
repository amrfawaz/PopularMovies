//
//  MovieViewModel.swift
//  
//
//  Created by AmrFawaz on 14/06/2024.
//

import Foundation
import AppConfigurations

final class MovieViewModel: ObservableObject {
    @Published var movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var posterImagePath: String {
        AppConstants.moviePosterRoot.rawValue + movie.posterPath
    }

    var movieName: String {
        movie.originalTitle
    }

    var movieReleaseDate: String {
        movie.releaseDate
    }
}

#if DEBUG
extension MovieViewModel {
    static var mockListCard: MovieViewModel {
        MovieViewModel(movie: .mockedMovie)
    }
}
#endif
