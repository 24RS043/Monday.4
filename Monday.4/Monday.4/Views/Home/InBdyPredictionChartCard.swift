import SwiftUI
import SwiftData
import Charts

struct InBodyPredictionChartCard: View {
    @Query(sort: \InBodyRecord.date, order: .forward)
    private var records: [InBodyRecord]

    @State private var selectedMetric: InBodyMetric = .weight

    private var points: [InBodyPredictionPoint] {
        InBodyPredictionService.makePredictionPoints(
            records: records,
            metric: selectedMetric
        )
    }

    private var latestActual: InBodyRecord? {
        records.sorted { $0.date < $1.date }.last
    }

    private var latestPrediction: InBodyPredictionPoint? {
        points.last { $0.isPrediction }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if records.isEmpty {
                emptyView
            } else {
                chartView
                predictionSummary
            }
        }
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var header: some View {
        HStack {
            Text("体組成の予測")
                .font(.headline)

            Spacer()

            Picker("項目", selection: $selectedMetric) {
                ForEach(InBodyMetric.allCases) { metric in
                    Text(metric.rawValue).tag(metric)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("まだ記録がありません")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
    }

    private var chartView: some View {
        Chart {
            ForEach(points.filter { !$0.isPrediction }) { point in
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
            }

            ForEach(points.filter { $0.isPrediction }) { point in
                LineMark(
                    x: .value("日付", point.date),
                    y: .value(selectedMetric.rawValue, point.value)
                )
                .foregroundStyle(.blue.opacity(0.35))
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 3,
                        dash: [6, 6]
                    )
                )
                .symbol {
                    Circle()
                        .fill(.blue.opacity(0.35))
                        .frame(width: 8, height: 8)
                }
            }

            if let latestActual {
                PointMark(
                    x: .value("最新日", latestActual.date),
                    y: .value(
                        "最新値",
                        InBodyPredictionService.value(
                            from: latestActual,
                            metric: selectedMetric
                        )
                    )
                )
                .foregroundStyle(.blue)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let number = value.as(Double.self) {
                        Text("\(number, specifier: "%.1f")\(selectedMetric.unit)")
                    }
                }
            }
        }
        .frame(height: 260)
    }

    private var predictionSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("予測値")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let latestPrediction {
                        Text("\(latestPrediction.value, specifier: "%.1f")\(selectedMetric.unit)")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)
                    }
                }

                Spacer()

                if let latestActual, let latestPrediction {
                    let current = InBodyPredictionService.value(
                        from: latestActual,
                        metric: selectedMetric
                    )
                    let diff = latestPrediction.value - current

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("現在から")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("\(diff >= 0 ? "+" : "")\(diff, specifier: "%.1f")\(selectedMetric.unit)")
                            .font(.title3.bold())
                            .foregroundStyle(diff >= 0 ? .red : .blue)
                    }
                }
            }

            HStack(spacing: 16) {
                Label("実測値", systemImage: "circle.fill")
                    .foregroundStyle(.blue)

                Label("予測値", systemImage: "circle.fill")
                    .foregroundStyle(.blue.opacity(0.35))
            }
            .font(.caption)
        }
    }
}
