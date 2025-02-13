//
//  ApiManager.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

enum ApiError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError
    
    var errorDescription: String {
            switch self {
            case .invalidURL:
                return K.invalidURL
            case .noData:
                return K.noData
            case .decodingError(let error):
                return "\(K.decodingError) \(error)"
            case .networkError(let error):
                return "\(K.networkError) \(error)"
            case .serverError:
                return K.serverError
            }
    }
}

final class ApiManager {
    func fetchItems(urlString: String) async throws -> [Item] {
        guard let url = URL(string: urlString) else {
            print("[DEBUG] Invalid URL")
            throw ApiError.invalidURL
        }
        
        do {
            print("[DEBUG] Starting request to URL: \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("[DEBUG] Invalid HTTP response")
                throw ApiError.serverError
            }
            
            print("[DEBUG] HTTP Status Code: \(httpResponse.statusCode)")
            
            guard !data.isEmpty else {
                print("[DEBUG] No data received from server")
                throw ApiError.noData
            }
            
            do {
                var items = try JSONDecoder().decode([Item].self, from: data)
                for i in 0..<items.count {
                    items[i].images = cleanImageURLs(from: items[i].images)
                }
                print("[DEBUG] Decoding successful: \(items.count)")
                return items
            }
            catch let decodingError {
                print("[DEBUG] Decoding failed: \(decodingError)")
                throw ApiError.decodingError(decodingError)
            }
        }
        catch let networkError {
            print("[DEBUG] Network error: \(networkError)")
            throw ApiError.networkError(networkError)
        }
    }
    
    func cleanImageURLs(from images: [String]) -> [String] {
        return images.compactMap { image in
            let cleaned = image
                .replacingOccurrences(of: "\"", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
            return cleaned
        }
    }
}
