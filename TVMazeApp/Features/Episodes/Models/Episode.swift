//
//  Episode.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation

struct Episode: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String?
    let image: ShowImage?
    let rating: Rating?
}
