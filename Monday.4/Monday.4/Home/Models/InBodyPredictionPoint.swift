import Foundation

struct InBodyPredictionPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let isPrediction: Bool
}
