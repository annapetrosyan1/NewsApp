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
    
    private func setupTempAPIKey() {
        #if DEBUG
        let tempKey = "908229715ee245d7a5b4e3088b37b771"
        
        // проверяем, что ключ не пустой и сохраняем
        if !tempKey.isEmpty {
            let success = APIKeyManager.shared.saveAPIKey(tempKey)
            if success {
                print("✅ API ключ сохранен в Keychain")
            } else {
                print("❌ Ошибка сохранения ключа в Keychain")
            }
        } else {
            print("❌ API ключ не найден. Вставьте ключ в setupTempAPIKey()")
        }
        #endif
    }
}
