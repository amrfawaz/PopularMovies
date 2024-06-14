//
//  PopularMoviesList.swift
//  
//
//  Created by AmrFawaz on 14/06/2024.
//

import CoreInterface
import SwiftUI

public struct PopularMoviesListView: View {
    private enum Constants {
        static let pageTitle = "Explore Popular Movies"
    }

    @StateObject private var viewModel = PopularMoviesViewModel(
        services: DefaultPopularMoviesService()
    )
    @State private var path = NavigationPath()
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: $path) {
            content
                .padding(.vertical, Style.Spacing.md)
                .onAppear {
                    Task {
                        await viewModel.fetchPopularMovies()
                    }
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
        Text(PopularMoviesListView.Constants.pageTitle)
            .typography(.heading01)
            .foregroundStyle(.black)
    }

    private var list: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    MovieView(viewModel: MovieViewModel(movie: movie))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            }
        }
//        .navigationDestination(for: Movie.self) { giveaway in
//            GiveawayDetailsView(
//                viewModel: GiveawayDetailsViewModel(giveaway: giveaway),
//                path: $path
//            )
//        }
    }
}

#Preview {
    PopularMoviesListView()
}
