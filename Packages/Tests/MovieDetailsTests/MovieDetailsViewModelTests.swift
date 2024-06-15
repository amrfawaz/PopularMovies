//
//  MovieDetailsViewModelTests.swift
//  
//
//  Created by AmrFawaz on 15/06/2024.
//

import XCTest

@testable import MovieDetails
@testable import AppConfigurations

final class MovieDetailsViewModelTests: XCTestCase {
    var viewModel: MovieDetailsViewModel!
    var mockService: MockMovieDetailsService!

    override func setUp() {
        super.setUp()
        mockService = MockMovieDetailsService()
        viewModel = MovieDetailsViewModel(movieID: 123)
        viewModel.services = mockService // Replace the service with the mock
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchMovieDetailsSuccess() async {
        // Given
        let mockDetails = MovieDetails.mockedMovieDetails
        mockService.movieDetails = mockDetails

        // When
        await viewModel.fetchMovieDetails()

        // Then
        XCTAssertEqual(viewModel.title, "Kingdom of the Planet of the Apes")
        XCTAssertEqual(viewModel.posterImagePath, AppConstants.moviePosterRoot.rawValue + "/gKkl37BQuKTanygYQG1pyYgLVgf.jpg")
        XCTAssertEqual(viewModel.releaseDate, "2024-05-08")
        XCTAssertEqual(viewModel.genres, "Science Fiction, Adventure, Action")
        XCTAssertEqual(viewModel.overview, "Several generations in the future following Caesar's reign, apes are now the dominant species and live harmoniously while humans have been reduced to living in the shadows. As a new tyrannical ape leader builds his empire, one young ape undertakes a harrowing journey that will cause him to question all that he has known about the past and to make choices that will define a future for apes and humans alike.")
        XCTAssertEqual(viewModel.duration, "2h 25m")
        XCTAssertEqual(viewModel.rating, "68.21 %")
    }

    func testFetchMovieDetailsFailure() async {
        // Given
        mockService.shouldReturnError = true

        // When
        await viewModel.fetchMovieDetails()

        // Then
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.posterImagePath, "")
        XCTAssertEqual(viewModel.releaseDate, "")
        XCTAssertEqual(viewModel.genres, "")
        XCTAssertEqual(viewModel.overview, "")
        XCTAssertEqual(viewModel.duration, "")
        XCTAssertEqual(viewModel.rating, "")
    }
}
