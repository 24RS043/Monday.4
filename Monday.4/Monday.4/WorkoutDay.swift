//
//  WorkoutDay.swift
//  Monday.4
//
//  Created by Morimoto Taketo on 2026/07/13.
//

import Foundation
import SwiftData

@Model
final class WorkoutDay {

    var id: UUID
    var date: Date

    init(
        id: UUID = UUID(),
        date: Date = .now
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
    }

}
