//
//  NetworkManager.swift
//
//
//  Created by AmrFawaz on 14/06/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case invalidURL
    case noData
    case decodingError

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    // Add other HTTP methods as needed
}
public protocol NetworkRequest {
    var method: HTTPMethod { get }
    var url: String { get }
    var headers: [String: String] { get }
    var params: [String: String]? { get }
}

protocol Service {
    func fetchData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public actor NetworkManager {

    public init() {}

    public func request<T: Decodable>(request: URLRequest, of type: T.Type) async throws -> T {
        // Perform the request using URLSession
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    continuation.resume(throwing: URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(statusCode)"]))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    continuation.resume(returning: decodedObject)
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
}
