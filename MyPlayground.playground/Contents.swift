import UIKit

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
               JSONSerialization.jsonObject(with: self,
               options: []),
            let jsonData = try?
               JSONSerialization.data(withJSONObject:
               jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
               encoding: .utf8) else {
                print("Failed to read JSON Object.")
                return
        }
        print(prettyJSONString)
    }
}

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

enum ItemError: Error, LocalizedError {
    case itemsNotFound
}

let baseURL = URL(string: "https://itunes.apple.com/search")!
var query = [
    "term": "The+Living+Tombstone",
    "media": "music",
    "country": "US"
]

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

Task {
    do {
        let itemsInfo = try await fetchItems(matching: query)
        for item in itemsInfo {
            print("""
            Name: \(item.name)
            Artist: \(item.artist)
            Kind: \(item.kind)
            Artwork URL: \(item.artworkURL)
            
            """)
        }
    } catch {
       print(error)
    }
}
