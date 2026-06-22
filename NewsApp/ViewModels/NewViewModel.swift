import Foundation
import SwiftUI
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadNews() {
        isLoading = true
        errorMessage = nil
        
        NetworkService.shared.fetchNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                print("✅ Загружено \(articles.count) статей")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                print("❌ Ошибка: \(error.localizedDescription)")
            }
            self?.isLoading = false
        }
    }
}
