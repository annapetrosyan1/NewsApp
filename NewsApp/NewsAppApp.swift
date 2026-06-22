import SwiftUI

@main
struct NewsAppApp: App {
    init() {
        setupTempAPIKey()
    }
    
    var body: some Scene {
        WindowGroup {
            NewsListView()
        }
    }
}
