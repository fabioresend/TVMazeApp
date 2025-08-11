//
//  TestData.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp

class TestData {

    static let sampleShow = Show(
        id: 1,
        name: "Breaking Bad",
        genres: ["Drama", "Crime"],
        schedule: Schedule(time: "21:00", days: ["Sunday"]),
        image: ShowImage(medium: "https://example.com/image.jpg", original: nil),
        summary: "<p>A high school chemistry teacher diagnosed with cancer</p>",
        rating: Rating(average: 9.5),
        embedded: nil
    )

    static let sampleShows = [
        Show(id: 1, name: "Breaking Bad", genres: ["Drama"], schedule: nil, image: nil, summary: nil, rating: Rating(average: 9.5), embedded: nil),
        Show(id: 2, name: "Better Call Saul", genres: ["Drama"], schedule: nil, image: nil, summary: nil, rating: Rating(average: 8.7), embedded: nil),
        Show(id: 3, name: "The Wire", genres: ["Drama", "Crime"], schedule: nil, image: nil, summary: nil, rating: Rating(average: 9.3), embedded: nil)
    ]

    static let sampleEpisodes = [
        Episode(id: 1, name: "Pilot", number: 1, season: 1, summary: nil, image: nil, rating: Rating(average: 7.7)),
        Episode(id: 2, name: "Cat's in the Bag...", number: 2, season: 1, summary: nil, image: nil, rating: Rating(average: 8.2)),
        Episode(id: 3, name: "Four Days Out", number: 1, season: 2, summary: nil, image: nil, rating: Rating(average: 9.1))
    ]

    static let sampleSearchResults = [
        SearchShowResult(score: 0.9, show: sampleShow)
    ]

    static let sampleShowsJSON = """
    [
        {
            "id": 1,
            "name": "Breaking Bad",
            "genres": ["Drama", "Crime", "Thriller"],
            "schedule": {
                "time": "21:00",
                "days": ["Sunday"]
            },
            "image": {
                "medium": "https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg",
                "original": "https://static.tvmaze.com/uploads/images/original_untouched/0/2400.jpg"
            },
            "summary": "<p>A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine.</p>",
            "rating": {
                "average": 9.5
            }
        },
        {
            "id": 2,
            "name": "Better Call Saul",
            "genres": ["Drama", "Crime"],
            "schedule": {
                "time": "21:00",
                "days": ["Monday"]
            },
            "rating": {
                "average": 8.7
            }
        }
    ]
    """

    static let sampleEpisodesJSON = """
    [
        {
            "id": 1,
            "name": "Pilot",
            "number": 1,
            "season": 1,
            "summary": "<p>Walter White, a struggling high school chemistry teacher, is diagnosed with lung cancer.</p>",
            "image": {
                "medium": "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg"
            },
            "rating": {
                "average": 7.7
            }
        },
        {
            "id": 2,
            "name": "Cat's in the Bag...",
            "number": 2,
            "season": 1,
            "summary": "<p>Walt and Jesse attempt to tie up loose ends.</p>",
            "rating": {
                "average": 8.2
            }
        },
        {
            "id": 3,
            "name": "Four Days Out",
            "number": 1,
            "season": 2,
            "summary": "<p>Walt and Jesse get stranded in the desert.</p>",
            "rating": {
                "average": 9.1
            }
        }
    ]
    """

    static let sampleSearchResultsJSON = """
    [
        {
            "score": 0.9026309,
            "show": {
                "id": 1,
                "name": "Breaking Bad",
                "genres": ["Drama", "Crime", "Thriller"],
                "summary": "<p>A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine.</p>",
                "rating": {
                    "average": 9.5
                }
            }
        }
    ]
    """

    static func decodeJSON<T: Decodable>(_ json: String, as type: T.Type) -> T? {
        guard let data = json.data(using: .utf8) else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try? decoder.decode(type, from: data)
    }
}

extension TestData {
    // Validate that our test data matches real API structure
    static func validateTestData() -> Bool {
        // Test shows JSON parsing
        guard let shows = decodeJSON(sampleShowsJSON, as: [Show].self),
              !shows.isEmpty else {
            return false
        }
        
        // Test episodes JSON parsing
        guard let episodes = decodeJSON(sampleEpisodesJSON, as: [Episode].self),
              !episodes.isEmpty else {
            return false
        }
        
        // Test search results JSON parsing
        guard let searchResults = decodeJSON(sampleSearchResultsJSON, as: [SearchShowResult].self),
              !searchResults.isEmpty else {
            return false
        }
        
        return true
    }
}
