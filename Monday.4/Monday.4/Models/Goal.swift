import Foundation
import SwiftData
 
@Model
final class Goal {
    var id: UUID
    var exerciseName: String
    var targetWeight: Double
 
    init(
        id: UUID = UUID(),
        exerciseName: String,
        targetWeight: Double
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.targetWeight = targetWeight
    }
}
