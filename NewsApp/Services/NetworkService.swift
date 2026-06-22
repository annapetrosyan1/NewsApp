@preconcurrency import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    private var apiKey: String? {
        return APIKeyManager.shared.getAPIKey()
    }
    
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    private let country = "us"
    
    func fetchNews(completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        guard let apiKey = apiKey else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API ключ не найден"])))
            return
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Неверный URL"])))
            return
        }
        
        print("🔗 Запрос к API: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // Используем nonisolated для декодирования
                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(newsResponse.articles))
                }
            } catch {
                print("❌ Ошибка декодирования: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
