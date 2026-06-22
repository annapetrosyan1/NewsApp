import Foundation

// MARK: - News Response
@preconcurrency struct NewsResponse: Codable, @unchecked Sendable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

// MARK: - News Article
@preconcurrency struct NewsArticle: Codable, Identifiable, @unchecked Sendable {
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description
        case url, urlToImage, publishedAt
    }
}

// MARK: - Source
@preconcurrency struct Source: Codable, @unchecked Sendable {
    let name: String
}

// MARK: - Computed Properties
extension NewsArticle {
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: publishedAt) else {
            return "Н/Д"
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MM/dd/yyyy"
        return displayFormatter.string(from: date)
    }
}
