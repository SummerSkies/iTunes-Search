//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Juliana Nielson on 4/18/23.
//

import Foundation
import UIKit

enum ItemError: Error, LocalizedError {
    case itemsNotFound
    case photoNotFound
}

class StoreItemController {
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw ItemError.itemsNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ItemError.photoNotFound
        }
        
        guard let image = UIImage(data: data) else {
            throw ItemError.photoNotFound
        }
        
        return image
    }
}
