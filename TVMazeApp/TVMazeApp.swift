//
//  TVMazeApp.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI
import SwiftData

@main
struct TVMazeApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
        .modelContainer(for: FavoriteShow.self)
    }
}

struct MainContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @Environment(\.modelContext) private var modelContext
    @State private var favoritesManager: FavoritesManager?

    var body: some View {
        Group {
            if let favoritesManager {
                if authManager.isAuthenticated || !authManager.hasSetupPIN {
                    MainTabView(authManager: authManager,
                                favoritesManager: favoritesManager)
                } else if authManager.hasSetupPIN {
                    AuthenticationView(authManager: authManager)
                } else {
                    PINSetupView(authManager: authManager)
                }
            } else {
                LoadingView()
            }
        }
        .onAppear {
            if favoritesManager == nil {
                favoritesManager = FavoritesManager(modelContext: modelContext)
            }
        }
    }
}
