import Foundation

enum MeteoriteServiceError: Error {
    case invalidResponse
}

struct MeteoriteService {
    let baseUrl = "https://data.nasa.gov/resource/gh4g-9sfh.json"
    let urlSession: URLSession
    let decoder = JSONDecoder()
    let appToken: String
    
    init() {
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let appTokenValue = NSDictionary(contentsOfFile: keysPath)?.value(forKey: "NasaAppToken") as? String
        else {
            fatalError("API NasaAppToken is missing from Keys.plist")
        }
        
        appToken = appTokenValue
        
        //let configuration = URLSessionConfiguration.default
        //configuration.requestCachePolicy = .useProtocolCachePolicy
        urlSession = URLSession(configuration: .default)
    }
    
    func performRequest(completion: @escaping (Result<[Meteorite], MeteoriteServiceError>) -> Void) {
        
        guard var components = URLComponents(string: baseUrl) else {
            fatalError("Malformed base URL")
        }
        
        components.queryItems = ["$limit": "1000", "$order": "mass DESC", "$where": "date_extract_y(year) >= 2011"].map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else {
            fatalError("Malformed URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(appToken, forHTTPHeaderField: "X-App-Token")
        //urlRequest.addValue("max-age=\(60*60*24)", forHTTPHeaderField: "Cache-Control")
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let meteoritesJson = try? self.decoder.decode([Meteorite.Json].self, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let meteorites = meteoritesJson
                .compactMap { Meteorite(fromJson: $0) }
            
            completion(.success(meteorites))
        }
        
        task.resume()
    }
    
    var meteorites: [Meteorite] {
        return []
    }
    
    func getMeteorite(index: Int) -> Meteorite {
        meteorites[index]
    }
}
