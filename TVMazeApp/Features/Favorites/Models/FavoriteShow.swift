//
//  FavoriteShow.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import SwiftData

// MARK: - SwiftData Models
@Model
class FavoriteShow {
    @Attribute(.unique) var showId: Int
    var name: String
    var genresString: String?
    var scheduleTime: String?
    var scheduleDaysString: String?
    var imageURL: String?
    var summary: String?
    var rating: Double?
    var dateAdded: Date

    var genres: [String] {
        get {
            guard let genresString else { return [] }
            return genresString.components(separatedBy: ",")
        }
        set {
            genresString = newValue.joined(separator: ",")
        }
    }

    var scheduleDays: [String] {
        get {
            guard let scheduleDaysString else { return [] }
            return scheduleDaysString.components(separatedBy: ",")
        }
        set {
            scheduleDaysString = newValue.joined(separator: ",")
        }
    }

    init(from show: Show) {
        self.showId = show.id
        self.name = show.name
        self.genresString = (show.genres ?? []).joined(separator: ",")
        self.scheduleTime = show.schedule?.time
        self.scheduleDaysString = (show.schedule?.days ?? []).joined(separator: ",")
        self.imageURL = show.image?.medium
        self.summary = show.summary
        self.rating = show.rating?.average
        self.dateAdded = Date()
    }

    func toShow() -> Show {
        let schedule = (scheduleTime != nil || !scheduleDays.isEmpty) ?
        Schedule(time: scheduleTime ?? "", days: scheduleDays) : nil

        let image = imageURL != nil ?
        ShowImage(medium: imageURL, original: nil) : nil

        let rating = self.rating != nil ?
        Rating(average: self.rating) : nil

        return Show(
            id: showId,
            name: name,
            genres: genres.isEmpty ? nil : genres,
            schedule: schedule,
            image: image,
            summary: summary,
            rating: rating,
            embedded: nil
        )
    }
}
