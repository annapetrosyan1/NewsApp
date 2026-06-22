import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if let url = URL(string: article.url) {
                    WebView(url: url, isLoading: $isLoading)
                        .overlay {
                            if isLoading {
                                VStack {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                    Text("Загрузка статьи...")
                                        .padding(.top, 8)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "safari.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Не удалось загрузить статью")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle(article.source.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
