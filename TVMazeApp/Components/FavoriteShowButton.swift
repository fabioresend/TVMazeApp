//
//  FavoriteShowButton.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

enum FavoriteButtonStyle {
    case image
    case textAndImage
}

struct FavoriteShowButton: View {
    let show: Show
    let favoritesManager: FavoritesManager
    let style: FavoriteButtonStyle
    @State private var isAnimating = false

    var isFavorite: Bool {
        favoritesManager.isFavorite(show)
    }

    var imageName: String {
        isFavorite ? "heart.fill" : "heart"
    }

    var imageColor: Color {
        isFavorite ? .red : .gray
    }

    var title: String {
        isFavorite ? "Remove from Favorites" : "Add to Favorites"
    }

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating = true
                favoritesManager.toggleFavorite(show)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = false
                }
            }
        }) {
            switch style {
                case .image:
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(imageColor)
                    .font(.title2)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
            case .textAndImage:
                Label(
                    title,
                    systemImage: imageName
                )
                .font(.subheadline)
                .foregroundColor(imageColor)
            }
        }
    }
}
