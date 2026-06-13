import Foundation
import SwiftData

@Model
final class InBodyRecord {
    var id: UUID
    var date: Date
    var weight: Double          // 体重(kg)
    var muscleMass: Double      // 筋肉量(kg)
    var bodyFatMass: Double     // 体脂肪量(kg)
    var bmi: Double             // BMI
    var bodyFatPercentage: Double // 体脂肪率(%)
    var photoData: Data?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        weight: Double,
        muscleMass: Double,
        bodyFatMass: Double,
        bmi: Double,
        bodyFatPercentage: Double,
        photoData: Data? = nil
    ) {
        self.id = id
        self.date = date
        self.weight = weight
        self.muscleMass = muscleMass
        self.bodyFatMass = bodyFatMass
        self.bmi = bmi
        self.bodyFatPercentage = bodyFatPercentage
        self.photoData = photoData
    }
}
