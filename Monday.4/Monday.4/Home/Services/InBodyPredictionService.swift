import Foundation

enum InBodyPredictionService {
    static func makePredictionPoints(
        records: [InBodyRecord],
        metric: InBodyMetric
    ) -> [InBodyPredictionPoint] {
        let sortedRecords = records.sorted { $0.date < $1.date }

        guard sortedRecords.count >= 2,
              let firstDate = sortedRecords.first?.date,
              let latestDate = sortedRecords.last?.date
        else {
            return sortedRecords.map {
                InBodyPredictionPoint(
                    date: $0.date,
                    value: metric.value(from: $0),
                    isPrediction: false
                )
            }
        }

        let calendar = Calendar.current
        let baseDate = calendar.startOfDay(for: firstDate)

        let samples = sortedRecords.map { record -> (x: Double, y: Double) in
            let recordDate = calendar.startOfDay(for: record.date)
            let days = calendar.dateComponents([.day], from: baseDate, to: recordDate).day ?? 0
            return (Double(days), metric.value(from: record))
        }

        let regression = linearRegression(samples: samples)

        let actualPoints = sortedRecords.map {
            InBodyPredictionPoint(
                date: $0.date,
                value: metric.value(from: $0),
                isPrediction: false
            )
        }

        let latestDay = calendar.dateComponents(
            [.day],
            from: baseDate,
            to: calendar.startOfDay(for: latestDate)
        ).day ?? 0

        let predictionPoints = [7, 14, 30].compactMap { offset -> InBodyPredictionPoint? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: latestDate) else {
                return nil
            }

            let x = Double(latestDay + offset)
            let value = max(regression.intercept + regression.slope * x, 0)

            return InBodyPredictionPoint(
                date: date,
                value: value,
                isPrediction: true
            )
        }

        return actualPoints + predictionPoints
    }

    private static func linearRegression(
        samples: [(x: Double, y: Double)]
    ) -> (slope: Double, intercept: Double) {
        let count = Double(samples.count)
        let sumX = samples.reduce(0) { $0 + $1.x }
        let sumY = samples.reduce(0) { $0 + $1.y }
        let sumXY = samples.reduce(0) { $0 + $1.x * $1.y }
        let sumXX = samples.reduce(0) { $0 + $1.x * $1.x }
        let denominator = count * sumXX - sumX * sumX

        guard denominator != 0 else {
            return (0, sumY / count)
        }

        let slope = (count * sumXY - sumX * sumY) / denominator
        let intercept = (sumY - slope * sumX) / count
        return (slope, intercept)
    }
}
