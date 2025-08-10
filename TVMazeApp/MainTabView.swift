//
//  MainTabView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authManager: AuthenticationManager

    var body: some View {
        TabView {
            ShowListView(viewModel: ShowListViewModel())
                .tabItem {
                    Image(systemName: "tv")
                    Text("Shows")
                }

            SettingsView(viewModel: SettingsViewModel(authManager: authManager))
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct MainContentView: View {
    @StateObject private var authManager = AuthenticationManager()

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView(authManager: authManager)
            } else if authManager.hasSetupPIN {
                AuthenticationView(authManager: authManager)
            } else {
                PINSetupView(authManager: authManager)
            }
        }
    }
}
