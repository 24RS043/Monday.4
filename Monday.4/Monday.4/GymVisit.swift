//
//  GymVisit.swift
//  Monday.4
//
//  Created by Morimoto Taketo on 2026/06/15.
//

import Foundation
import SwiftData

@Model
final class GymVisit {

    var id: UUID
    var date: Date

    init(
        id: UUID = UUID(),
        date: Date = .now
    ) {
        self.id = id
        self.date = date
    }
}
