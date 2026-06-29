import Foundation

struct InBodyPredictionPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let isPrediction: Bool
}

enum InBodyMetric: String, CaseIterable, Identifiable {
    case weight = "体重"
    case muscleMass = "筋肉量"
    case bodyFatMass = "体脂肪量"
    case bmi = "BMI"
    case bodyFatPercentage = "体脂肪率"

    var id: String { rawValue }

    var unit: String {
        switch self {
        case .weight, .muscleMass, .bodyFatMass:
            return "kg"
        case .bmi:
            return ""
        case .bodyFatPercentage:
            return "%"
        }
    }
}

struct InBodyPredictionService {

    static func value(from record: InBodyRecord, metric: InBodyMetric) -> Double {
        switch metric {
        case .weight:
            return record.weight
        case .muscleMass:
            return record.muscleMass
        case .bodyFatMass:
            return record.bodyFatMass
        case .bmi:
            return record.bmi
        case .bodyFatPercentage:
            return record.bodyFatPercentage
        }
    }

    static func makePredictionPoints(
        records: [InBodyRecord],
        metric: InBodyMetric,
        predictionCount: Int = 4
    ) -> [InBodyPredictionPoint] {

        guard records.count >= 2 else {
            return records.map {
                InBodyPredictionPoint(
                    date: $0.date,
                    value: value(from: $0, metric: metric),
                    isPrediction: false
                )
            }
        }

        let sortedRecords = records.sorted { $0.date < $1.date }

        let actualPoints = sortedRecords.map {
            InBodyPredictionPoint(
                date: $0.date,
                value: value(from: $0, metric: metric),
                isPrediction: false
            )
        }

        let startDate = sortedRecords[0].date
        let xValues = sortedRecords.map {
            $0.date.timeIntervalSince(startDate) / 86400
        }
        let yValues = sortedRecords.map {
            value(from: $0, metric: metric)
        }

        let count = Double(xValues.count)
        let xMean = xValues.reduce(0, +) / count
        let yMean = yValues.reduce(0, +) / count

        let numerator = zip(xValues, yValues).reduce(0) {
            $0 + (($1.0 - xMean) * ($1.1 - yMean))
        }

        let denominator = xValues.reduce(0) {
            $0 + pow($1 - xMean, 2)
        }

        let slope = denominator == 0 ? 0 : numerator / denominator
        let intercept = yMean - slope * xMean

        let lastRecord = sortedRecords.last!
        let lastDate = lastRecord.date

        let predictionPoints = (1...predictionCount).compactMap { index -> InBodyPredictionPoint? in
            guard let futureDate = Calendar.current.date(
                byAdding: .weekOfYear,
                value: index,
                to: lastDate
            ) else {
                return nil
            }

            let futureX = futureDate.timeIntervalSince(startDate) / 86400
            let predictedValue = slope * futureX + intercept

            return InBodyPredictionPoint(
                date: futureDate,
                value: predictedValue,
                isPrediction: true
            )
        }

        return actualPoints + predictionPoints
    }
}
