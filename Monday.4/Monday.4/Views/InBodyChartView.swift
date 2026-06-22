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

                        // 過去 → 最新の増減を表示（記録が2件以上あるとき）
                        if records.count >= 2 {
                            changeSummary(latest: latest)
                                .padding(.top, 4)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("体組成グラフ")
        }
    }

    // MARK: - 増減サマリー

    /// 直近の1つ前の記録（前回比の計算に使う）
    private var previousRecord: InBodyRecord? {
        guard records.count >= 2 else { return nil }
        return records[records.count - 2]
    }

    private func changeSummary(latest: InBodyRecord) -> some View {
        let current = value(for: latest)
        let first = records.first.map { value(for: $0) }
        let previous = previousRecord.map { value(for: $0) }

        return HStack(spacing: 16) {
            deltaLabel(title: "前回比", from: previous, to: current)
            deltaLabel(title: "初回比", from: first, to: current, showPercent: true)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private func deltaLabel(
        title: String,
        from reference: Double?,
        to current: Double,
        showPercent: Bool = false
    ) -> some View {
        Text(deltaText(title: title, from: reference, to: current, showPercent: showPercent))
    }

    /// 「前回比 ▼2.1kg (3.3%)」のような増減テキストを組み立てる。
    /// 矢印で増減の方向、数値で変化量（絶対値）を示す。基準が無ければ「—」。
    private func deltaText(
        title: String,
        from reference: Double?,
        to current: Double,
        showPercent: Bool
    ) -> String {
        guard let ref = reference else { return "\(title) —" }
        let delta = current - ref
        let arrow = delta > 0.05 ? "▲" : (delta < -0.05 ? "▼" : "→")
        var text = "\(title) \(arrow)" + String(format: "%.1f", abs(delta)) + selectedMetric.unit
        if showPercent, ref != 0 {
            text += String(format: " (%.1f%%)", abs(delta / ref * 100))
        }
        return text
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
