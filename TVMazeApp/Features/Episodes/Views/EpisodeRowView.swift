//
//  EpisodeRowView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct EpisodeRowView: View {
    let episode: Episode

    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = episode.image?.medium {
                AsyncImageView(url: imageUrl, placeholder: "tv")
                    .frame(width: 60, height: 40)
                    .cornerRadius(6)
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 40)
                    .overlay(
                        Image(systemName: "tv")
                            .foregroundColor(.gray)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(episode.name)
                    .font(.subheadline)
                    .lineLimit(1)
            }

            Spacer()

            if let rating = episode.rating?.average {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
