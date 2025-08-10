//
//  EpisodeDetailView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = episode.image?.original ?? episode.image?.medium {
                    AsyncImageView(url: imageUrl, placeholder: "tv")
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(episode.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack {
                        Text(episode.episodeCode)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                        Spacer()

                        if let rating = episode.rating?.average {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", rating))
                            }
                            .font(.subheadline)
                        }
                    }
                }

                // Summary
                if let summary = episode.summary?.stripHTML() {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)

                        Text(summary)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

