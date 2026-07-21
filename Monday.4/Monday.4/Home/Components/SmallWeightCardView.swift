import SwiftUI
import Charts

struct SmallWeightCardView: View {
    let records: [InBodyRecord]

    private var sortedRecords: [InBodyRecord] {
        records.sorted { $0.date < $1.date }
    }

    private var latestWeight: Double? {
        sortedRecords.last?.weight
    }

    private var difference: Double {
        guard sortedRecords.count >= 2 else { return 0 }
        return sortedRecords[sortedRecords.count - 1].weight - sortedRecords[sortedRecords.count - 2].weight
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("体重の推移")
                .font(.headline)

            if let latestWeight {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", latestWeight))
                        .font(.system(size: 32, weight: .bold))

                    Text("kg")
                        .font(.subheadline)
                }

                Text(String(format: "%@ %.1fkg", difference >= 0 ? "↑" : "↓", abs(difference)))
                    .font(.subheadline)
                    .foregroundStyle(difference >= 0 ? .red : .blue)

                Chart(sortedRecords) { record in
                    LineMark(
                        x: .value("日付", record.date),
                        y: .value("体重", record.weight)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 70)
            } else {
                Text("InBody記録がありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 100)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}
