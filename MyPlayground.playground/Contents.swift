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
    var artworkUrl60: URL
    var collectionPrice: Double
    var wrapperType: String
    var country: String
    var isStreamable: Bool
    var releaseDate: Date
    var artistId: Int
    var collectionViewUrl: URL
    var kind: String
    var trackExplicitness: String
    var currency: String
    var artistName: String
    var artistViewUrl: URL
    var artworkUrl30: URL
    var trackViewUrl: URL
    var discCount: Int
    var collectionCensoredName: String
    var collectionId: Int
    var trackCensoredName: String
    var previewUrl: URL
    var trackTimeMillis: Int
    var trackName: String
    var trackPrice: Double
    var collectionName: String
    var artworkUrl100: URL
    var trackCount: Int
    var trackId: Int
    var discNumber: Int
    var collectionExplicitness: String
    var trackNumber: Int
    var primaryGenreName: String
    
    enum AdditionalKeys: CodingKey {
        case longDescription
    }
    
    /*
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
        artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkUrl30 = try values.decode(URL.self, forKey:
           CodingKeys.artworkUrl30)
        artworkUrl60 = try values.decode(URL.self, forKey:
           CodingKeys.artworkUrl60)
        artworkUrl100 = try values.decode(URL.self, forKey:
           CodingKeys.artworkUrl100)
        
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
     */
}

let baseURL = URL(string: "https://itunes.apple.com/search")!
var queryItems = ["term": "The+Living+Tombstone", "media": "music", "country": "US"]

var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

Task {
    let (data, response) = try await URLSession.shared.data(from: components.url!)
    if let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode == 200 {
        data.prettyPrintedJSONString()
    }
}
    
