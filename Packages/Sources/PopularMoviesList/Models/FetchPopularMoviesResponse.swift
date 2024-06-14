//
//  FetchPopularMoviesResponse.swift
//
//
//  Created by AmrFawaz on 14/06/2024.
//

import Foundation

public struct FetchPopularMoviesResponse: Codable {
    let page: Int
    let movies: [Movie]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movies = "results"
        case totalPages = "total_pages"
    }
}
