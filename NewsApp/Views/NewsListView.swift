import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedArticle: NewsArticle?
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Загрузка новостей...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Повторить") {
                            viewModel.loadNews()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.articles) { article in
                                NewsCardView(article: article)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.loadNews()
                    }
                }
            }
            .navigationTitle("Новости")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.loadNews()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadNews()
        }
        .sheet(item: $selectedArticle) { article in
            NewsDetailView(article: article)
        }
    }
}

// MARK: - News Card View
struct NewsCardView: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageURL = article.urlToImage, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Color.gray.opacity(0.2)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .overlay(Image(systemName: "photo.fill").foregroundColor(.gray))
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            HStack {
                Text(article.source.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                if let author = article.author, !author.isEmpty {
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(author)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(article.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(article.title)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
            
            Text(article.description ?? "Нет описания")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
