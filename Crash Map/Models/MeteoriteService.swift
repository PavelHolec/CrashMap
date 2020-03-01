import Foundation

enum MeteoriteServiceError: Error {
    case invalidResponse
}

struct MeteoriteService {
    
    private let baseUrl: String
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    private let appToken: String
    
    init(url: String, appToken: String) {
        self.baseUrl = url
        self.appToken = appToken
        
        //let configuration = URLSessionConfiguration.default
        //configuration.requestCachePolicy = .useProtocolCachePolicy
        urlSession = URLSession(configuration: .default)
    }
    
    func getMeteorites(sinceYear year: Int, completion: @escaping (Result<[Meteorite], MeteoriteServiceError>) -> Void) {
        let queryItems = [
            "$where": "date_extract_y(year) >= \(year)",
            "$order": "mass DESC"
        ]
        performRequest(withQueryItems: queryItems, completion: completion)
    }
    
    func performRequest(withQueryItems queryItems: [String: String], completion: @escaping (Result<[Meteorite], MeteoriteServiceError>) -> Void) {
        
        guard var components = URLComponents(string: baseUrl) else {
            fatalError("Malformed base URL")
        }
        
        components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            fatalError("Malformed URL")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(appToken, forHTTPHeaderField: "X-App-Token")
        //urlRequest.addValue("max-age=\(60*60*24)", forHTTPHeaderField: "Cache-Control")
        
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
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
        
        dataTask.resume()
    }
}
