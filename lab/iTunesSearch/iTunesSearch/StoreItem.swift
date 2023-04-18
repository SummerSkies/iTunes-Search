//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Juliana Nielson on 4/18/23.
//

import Foundation

struct StoreItem: Codable {
    let kind: String
    let artist: String
    let artworkURL: URL
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case kind
        case artist = "artistName"
        case name = "trackName"
        case artworkURL = "artworkUrl30"
        case description
    }
    
    enum AdditionalKeys: CodingKey {
        case description
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey:
           CodingKeys.artworkURL)
    
        if let description = try? values.decode(String.self,
                                                forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy:
               AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self,
               forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
}

struct SearchResponse: Codable {
    let results: [StoreItem]
}
