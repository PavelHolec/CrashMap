import Foundation

enum MeteoriteServiceError: Error {
    case invalidResponse
}

struct MeteoriteService {
    let baseUrl = "https://data.nasa.gov/resource/gh4g-9sfh.json"
    let decoder = JSONDecoder()
    let appToken: String
    
    init() {
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let appTokenValue = NSDictionary(contentsOfFile: keysPath)?.value(forKey: "NasaAppToken") as? String
        else {
            fatalError("AppKey is missing")
        }
        
        appToken = appTokenValue
    }
    
    func performRequest(completion: @escaping (Result<[Meteorite], MeteoriteServiceError>) -> Void) {
        guard let url = URL(string: baseUrl + "?$limit=30&year='2011-01-01T00:00:00'") else {
            fatalError("Malformed URL")
        }
        
        //.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(appToken, forHTTPHeaderField: "X-App-Token")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
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
                .sorted(by: { $0.massInGrams > $1.massInGrams })
            
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
