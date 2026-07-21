import Foundation

enum InBodyMetric: String, CaseIterable, Identifiable {
    case weight = "体重"
    case muscleMass = "筋肉量"
    case bodyFatPercentage = "体脂肪率"

    var id: Self { self }

    var unit: String {
        switch self {
        case .weight, .muscleMass:
            return "kg"
        case .bodyFatPercentage:
            return "%"
        }
    }

    func value(from record: InBodyRecord) -> Double {
        switch self {
        case .weight:
            return record.weight
        case .muscleMass:
            return record.muscleMass
        case .bodyFatPercentage:
            return record.bodyFatPercentage
        }
    }
}
