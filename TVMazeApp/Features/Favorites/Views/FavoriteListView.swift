//
//  FavoriteListView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct FavoriteListView: View {
    let favoritesManager: FavoritesManager
    @State private var selectedShow: Show?

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if favoritesManager.favoriteShows.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(favoritesManager.favoriteShows, id: \.showId) { favoriteShow in
                                let show = favoriteShow.toShow()
                                ShowCardView(show: show,
                                             favoritesManager: favoritesManager)
                                    .onTapGesture {
                                        selectedShow = show
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(item: $selectedShow) { show in
                ShowDetailView(viewModel: ShowDetailViewModel(show: show,
                                                              favoritesManager: favoritesManager))
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Add shows to your favorites by tapping the heart icon")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
