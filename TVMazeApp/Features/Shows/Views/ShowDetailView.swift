//
//  ShowDetailView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct SeriesDetailView: View {
    @StateObject private var viewModel: ShowDetailViewModel
    @State private var selectedEpisode: Episode?

    init(show: Show) {
        _viewModel = StateObject(wrappedValue: ShowDetailViewModel(show: show))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(show: viewModel.show)

                InfoSection(show: viewModel.show)

                Divider()

                if let summary = viewModel.show.summary?.stripHTML() {
                    SummarySection(summary: summary)
                }

                Divider()

                if viewModel.isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if !viewModel.episodes.isEmpty {
                    EpisodesSection(
                        groupedEpisodes: viewModel.groupedEpisodes,
                        selectedEpisode: $selectedEpisode
                    )
                } else {
                    Text("No episodes available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.show.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadEpisodes()
        }
        .sheet(item: $selectedEpisode) { episode in
            NavigationStack {
                EpisodeDetailView(episode: episode)
            }
        }
    }
}


// MARK: - Header Section
struct HeaderSection: View {
    let show: Show

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImageView(
                url: show.image?.medium,
                placeholder: "tv"
            )
            .frame(width: 150, height: 220)
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 12) {
                Text(show.name)
                    .font(.title2)
                    .fontWeight(.bold)

                if let rating = show.rating?.average {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f/10", rating))
                            .foregroundColor(.secondary)
                    }
                }

                if let genres = show.genres {
                    Text(genres.joined(separator: " / "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
    }
}

struct InfoSection: View {
    let show: Show

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let schedule = show.schedule,
               !schedule.days.isEmpty {
                InfoRow(
                    icon: "calendar",
                    title: "Schedule",
                    value: "\(schedule.days.joined(separator: ", ")) at \(schedule.time)"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct SummarySection: View {
    let summary: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(.headline)

            Text(summary)
                .font(.body)
                .lineLimit(isExpanded ? nil : 4)
                .animation(.linear(duration: 0.3), value: isExpanded)

            if summary.count > 200 {
                Button(isExpanded ? "Show Less" : "Show More") {
                    isExpanded.toggle()
                }
                .font(.caption)
                .foregroundColor(.accentColor)
            }
        }
    }
}

struct EpisodesSection: View {
    let groupedEpisodes: [Int: [Episode]]
    @Binding var selectedEpisode: Episode?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Episodes")
                .font(.headline)

            ForEach(groupedEpisodes.keys.sorted(), id: \.self) { season in
                if let episodes = groupedEpisodes[season] {
                    SeasonSection(
                        season: season,
                        episodes: episodes,
                        selectedEpisode: $selectedEpisode
                    )
                }
            }
        }
    }
}

struct SeasonSection: View {
    let season: Int
    let episodes: [Episode]
    @Binding var selectedEpisode: Episode?
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Season \(season)")
                        .font(.headline)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack {
                    let sortedEpisodes = episodes.sorted { $0.number < $1.number }

                    ForEach(Array(sortedEpisodes.enumerated()), id: \.1.id) { index, episode in
                        EpisodeRowView(episode: episode)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEpisode = episode
                            }

                        if index < sortedEpisodes.count - 1 {
                            Divider()
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
