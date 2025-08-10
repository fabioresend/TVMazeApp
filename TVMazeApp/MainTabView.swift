//
//  MainTabView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authManager: AuthenticationManager
    let favoritesManager: FavoritesManager

    var body: some View {
        TabView {
            ShowListView(viewModel: ShowListViewModel(favoritesManager: favoritesManager))
                .tabItem {
                    Image(systemName: "tv")
                    Text("Shows")
                }

            FavoriteListView(favoritesManager: favoritesManager)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }

            SettingsView(viewModel: SettingsViewModel(authManager: authManager))
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}
