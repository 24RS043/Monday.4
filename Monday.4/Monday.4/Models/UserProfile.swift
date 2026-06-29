import Foundation
import SwiftData

@Model
final class UserProfile {

    var name: String
    var gender: String
    var birthDate: Date

    // nilなら未入力
    var height: Double?
    var weight: Double?
    var targetWeight: Double?

    var activityLevel: String

    init(
        name: String = "",
        gender: String = "",
        birthDate: Date = Date(),
        height: Double? = nil,
        weight: Double? = nil,
        targetWeight: Double? = nil,
        activityLevel: String = ""
    ) {
        self.name = name
        self.gender = gender
        self.birthDate = birthDate
        self.height = height
        self.weight = weight
        self.targetWeight = targetWeight
        self.activityLevel = activityLevel
    }
}
