//
//  Show.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import SwiftData

struct Show: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let genres: [String]?
    let schedule: Schedule?
    let image: ShowImage?
    let summary: String?
    let rating: Rating?
    let embedded: Embedded?

    private enum CodingKeys: String, CodingKey {
        case id, name, genres, schedule, image, summary, rating
        case embedded = "_embedded"
    }
}

struct Schedule: Codable, Hashable {
    let time: String
    let days: [String]
}

struct ShowImage: Codable, Hashable {
    let medium: String?
    let original: String?
}

struct Rating: Codable, Hashable {
    let average: Double?
}

struct SearchShowResult: Codable {
    let score: Double
    let show: Show
}

struct Embedded: Codable, Hashable {
    let episodes: [Episode]?
}
