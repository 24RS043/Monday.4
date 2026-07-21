import SwiftUI
import Charts

struct BodyPredictionHomeCard: View {
    let records: [InBodyRecord]
    let onTap: () -> Void

    @State private var selectedMetric: InBodyMetric = .weight

    init(records: [InBodyRecord], onTap: @escaping () -> Void = {}) {
        self.records = records
        self.onTap = onTap
    }

    private var points: [InBodyPredictionPoint] {
        InBodyPredictionService.makePredictionPoints(
            records: records,
            metric: selectedMetric
        )
    }

    private var actualPoints: [InBodyPredictionPoint] {
        points.filter { !$0.isPrediction }
    }

    private var predictionPoints: [InBodyPredictionPoint] {
        points.filter { $0.isPrediction }
    }

    private var latestActual: InBodyPredictionPoint? {
        actualPoints.last
    }

    private var latestPrediction: InBodyPredictionPoint? {
        predictionPoints.last
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            header
            legend

            if records.count < 2 {
                emptyView
            } else {
                chartView
                predictionFooter
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("体組成の予測")
                    .font(.headline)

                Spacer()

                Button(action: onTap) {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("InBody履歴を開く")
            }

            Picker("項目", selection: $selectedMetric) {
                ForEach(InBodyMetric.allCases) { metric in
                    Text(metric.rawValue).tag(metric)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var legend: some View {
        HStack(spacing: 18) {
            HStack(spacing: 7) {
                Capsule()
                    .fill(.blue)
                    .frame(width: 34, height: 3)

                Text("実測値")
            }

            HStack(spacing: 7) {
                Capsule()
                    .fill(.blue.opacity(0.35))
                    .frame(width: 34, height: 3)

                Text("予測値")
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var emptyView: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)

            Text("InBody記録を2件以上追加すると予測が表示されます")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 210)
    }

    private var chartView: some View {
        Chart {
            ForEach(actualPoints) { point in
                LineMark(
                    x: .value("日付", point.date),
                    y: .value(selectedMetric.rawValue, point.value)
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .symbol {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                }
                .interpolationMethod(.catmullRom)
            }

            if let latestActual {
                ForEach([latestActual] + predictionPoints) { point in
                    LineMark(
                        x: .value("日付", point.date),
                        y: .value(selectedMetric.rawValue, point.value)
                    )
                    .foregroundStyle(.blue.opacity(0.35))
                    .lineStyle(StrokeStyle(lineWidth: 3, dash: [7, 7]))
                    .symbol {
                        Circle()
                            .fill(.blue.opacity(0.35))
                            .frame(width: 8, height: 8)
                    }
                    .interpolationMethod(.catmullRom)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                AxisGridLine()
                    .foregroundStyle(Color.gray.opacity(0.14))

                AxisValueLabel(format: .dateTime.month().day())
                    .foregroundStyle(.secondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
                AxisGridLine()
                    .foregroundStyle(Color.gray.opacity(0.14))

                AxisValueLabel {
                    if let number = value.as(Double.self) {
                        Text(String(format: "%.0f", number))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(height: 220)
    }

    private var predictionFooter: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(predictionDateText)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text("予測値")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(predictionValueText)
                .font(.title3.bold())
                .foregroundStyle(.blue)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Spacer(minLength: 6)

            VStack(alignment: .trailing, spacing: 4) {
                Text("現在から")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(diffText)
                    .font(.headline.bold())
                    .foregroundStyle(diffValue >= 0 ? .red : .blue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            Image(systemName: diffValue >= 0 ? "arrow.up" : "arrow.down")
                .font(.headline.bold())
                .foregroundStyle(diffValue >= 0 ? .red : .blue)
        }
        .padding(13)
        .background(.blue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var predictionDateText: String {
        guard let latestPrediction else { return "予測値" }
        return latestPrediction.date.formatted(.dateTime.month().day()) + " の予測"
    }

    private var predictionValueText: String {
        guard let latestPrediction else { return "--" }
        return String(format: "%.1f%@", latestPrediction.value, selectedMetric.unit)
    }

    private var diffValue: Double {
        guard let latestActual, let latestPrediction else { return 0 }
        return latestPrediction.value - latestActual.value
    }

    private var diffText: String {
        String(
            format: "%@%.1f%@",
            diffValue >= 0 ? "+" : "",
            diffValue,
            selectedMetric.unit
        )
    }
}
