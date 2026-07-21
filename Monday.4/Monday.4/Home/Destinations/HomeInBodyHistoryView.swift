import SwiftUI

struct HomeInBodyHistoryView: View {
    let records: [InBodyRecord]

    private var sortedRecords: [InBodyRecord] {
        records.sorted { $0.date > $1.date }
    }

    var body: some View {
        Group {
            if sortedRecords.isEmpty {
                ContentUnavailableView(
                    "InBody記録がありません",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("記録を追加すると履歴が表示されます。")
                )
            } else {
                List(Array(sortedRecords.enumerated()), id: \.offset) { _, record in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(record.date.formatted(date: .long, time: .omitted))
                            .font(.headline)

                        HStack {
                            value("体重", value: record.weight, unit: "kg")
                            value("筋肉量", value: record.muscleMass, unit: "kg")
                            value("体脂肪率", value: record.bodyFatPercentage, unit: "%")
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("InBody履歴")
    }

    private func value(_ title: String, value: Double, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(String(format: "%.1f%@", value, unit))
                .font(.subheadline.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
