import SwiftUI
import SwiftData
import Charts

/// InBody計測結果の推移グラフ
struct InBodyChartView: View {
    @Query(sort: \InBodyRecord.date, order: .forward) private var records: [InBodyRecord]

    enum Metric: String, CaseIterable, Identifiable {
        case weight = "体重"
        case muscleMass = "筋肉量"
        case bodyFatMass = "体脂肪量"
        case bmi = "BMI"
        case bodyFatPercentage = "体脂肪率"

        var id: String { rawValue }
        var unit: String {
            switch self {
            case .weight, .muscleMass, .bodyFatMass: return "kg"
            case .bmi: return ""
            case .bodyFatPercentage: return "%"
            }
        }
    }

    @State private var selectedMetric: Metric = .weight

    var body: some View {
        NavigationStack {
            VStack {
                Picker("項目", selection: $selectedMetric) {
                    ForEach(Metric.allCases) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if records.isEmpty {
                    Spacer()
                    Text("まだ記録がありません")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    Chart(records) { record in
                        LineMark(
                            x: .value("日付", record.date),
                            y: .value(selectedMetric.rawValue, value(for: record))
                        )
                        .symbol(.circle)
                        .interpolationMethod(.catmullRom)
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
                                if let v = value.as(Double.self) {
                                    Text("\(v, specifier: "%.1f")\(selectedMetric.unit)")
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(height: 300)

                    if let latest = records.last {
                        Text("最新: \(value(for: latest), specifier: "%.1f")\(selectedMetric.unit)")
                            .font(.title2)
                            .padding(.top, 8)
                    }
                }

                Spacer()
            }
            .navigationTitle("体組成グラフ")
        }
    }

    private func value(for record: InBodyRecord) -> Double {
        switch selectedMetric {
        case .weight: return record.weight
        case .muscleMass: return record.muscleMass
        case .bodyFatMass: return record.bodyFatMass
        case .bmi: return record.bmi
        case .bodyFatPercentage: return record.bodyFatPercentage
        }
    }
}

#Preview {
    InBodyChartView()
        .modelContainer(for: InBodyRecord.self, inMemory: true)
}
