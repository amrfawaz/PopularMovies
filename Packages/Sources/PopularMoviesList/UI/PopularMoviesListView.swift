//
//  PopularMoviesList.swift
//  
//
//  Created by AmrFawaz on 14/06/2024.
//

import Combine
import CoreInterface
import MovieDetails
import SwiftUI

public struct PopularMoviesListView: View {
    private enum Constants {
        static let pageTitle = "Explore Popular Movies"
        static let errorTitle = "Error"
    }

    @StateObject private var viewModel = PopularMoviesViewModel(
        services: DefaultPopularMoviesService()
    )

    @State private var path = NavigationPath()
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showAlert = false

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            content
                .padding(.vertical, Style.Spacing.md)
                .onFirstAppear {
                    await viewModel.fetchPopularMovies()
                }
                .alert(isPresented: Binding<Bool>(
                    get: { !viewModel.errorMessage.isEmpty },
                    set: { newValue in
                        if !newValue {
                            viewModel.errorMessage = ""
                        }
                    }
                )) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
    }
}

private extension PopularMoviesListView {
    private var content: some View {
        ScrollView {
            VStack(spacing: Style.Spacing.md) {
                title
                list
            }
        }
    }

    var title: some View {
        Text(Constants.pageTitle)
            .typography(.heading01)
            .foregroundStyle(.black)
    }

    private var list: some View {
        LazyVStack {
            ForEach(viewModel.movies) { movie in
                let movieViewModel = MovieViewModel(movie: movie)

                MovieView(viewModel: movieViewModel)
                    .onAppear {
                        // Trigger pagination when the last movie appears
                        if movie.id == viewModel.movies.last?.id {
                            Task {
                                await viewModel.fetchPopularMovies()
                            }
                        }
                    }
                    .onReceive(movieViewModel.subject) { action in
                        handleMovieViewAction(action, movie: movie)
                    }
            }
        }
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailsView(
                viewModel: MovieDetailsViewModel(movieID: movie.id),
                path: $path
            )
        }
    }

    private func handleMovieViewAction(
        _ action: MovieViewAction,
        movie: Movie
    ) {
        switch action {
        case .didTapMovieCard:
            path.append(movie)
        }
    }
}

#Preview {
    PopularMoviesListView()
}
