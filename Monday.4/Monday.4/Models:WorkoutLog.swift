import Foundation
import SwiftData

@Model
final class WorkoutLog {
    var id: UUID
    var date: Date
    var exerciseName: String
    var weight: Double
    var reps: Int
    var sets: Int
    var memo: String?

    init(id: UUID = UUID(), date: Date = .now, exerciseName: String, weight: Double, reps: Int, sets: Int, memo: String? = nil) {
        self.id = id
        self.date = date
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
        self.sets = sets
        self.memo = memo
    }
}

enum DefaultExercises {
    static let list: [String] = [
        "ベンチプレス", "スクワット", "デッドリフト", "ショルダープレス",
        "懸垂", "腕立て伏せ", "ラットプルダウン", "レッグプレス"
    ]
}
