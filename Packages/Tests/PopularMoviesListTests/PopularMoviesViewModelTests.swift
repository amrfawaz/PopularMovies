//
//  PopularMoviesViewModelTests.swift
//  
//
//  Created by AmrFawaz on 15/06/2024.
//

import XCTest

@testable import PopularMoviesList

class MockPopularMoviesService: PopularMoviesService {
    var canFetchNextPageResult: Bool = true
    var fetchPopularMoviesResult: Result<[Movie], Error> = .success([])

    func canFetechNextPage() -> Bool {
        return canFetchNextPageResult
    }

    func fetchPopularMovies() async -> Result<[Movie], Error> {
        return fetchPopularMoviesResult
    }
}

final class PopularMoviesViewModelTests: XCTestCase {
    func testFetchPopularMoviesSuccess() async {
        // Given
        let mockService = MockPopularMoviesService()
        let expectedMovies = [Movie(id: 1, originalTitle: "Movie 1", overview: "Overview 1", posterPath: "", releaseDate: "2024-01-01")]
        mockService.fetchPopularMoviesResult = .success(expectedMovies)

        let viewModel = PopularMoviesViewModel(services: mockService)

        // When
        await viewModel.fetchPopularMovies()

        // Then
        XCTAssertEqual(viewModel.movies, expectedMovies)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }

    func testFetchPopularMoviesFailure() async {
        // Given
        let mockService = MockPopularMoviesService()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.fetchPopularMoviesResult = .failure(expectedError)

        let viewModel = PopularMoviesViewModel(services: mockService)

        // When
        await viewModel.fetchPopularMovies()

        // Then
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, expectedError.localizedDescription)
    }
    
    func testFetchPopularMoviesWhenCannotFetchNextPage() async {
        // Given
        let mockService = MockPopularMoviesService()
        mockService.canFetchNextPageResult = false

        let viewModel = PopularMoviesViewModel(services: mockService)

        // Then
        await viewModel.fetchPopularMovies()

        // Assert
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
}
