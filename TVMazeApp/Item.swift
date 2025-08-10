//
//  Item.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
