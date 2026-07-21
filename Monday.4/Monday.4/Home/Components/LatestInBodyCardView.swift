import SwiftUI

struct LatestInBodyCardView: View {
    let record: InBodyRecord?
    let onShowHistory: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("最新InBody", systemImage: "chart.bar.fill")
                    .font(.headline)

                Spacer()

                Button(action: onShowHistory) {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("InBody履歴を開く")
            }

            if let record {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    metric(title: "体重", value: record.weight, unit: "kg")
                    metric(title: "筋肉量", value: record.muscleMass, unit: "kg")
                    metric(title: "体脂肪量", value: record.bodyFatMass, unit: "kg")
                    metric(title: "BMI", value: record.bmi, unit: "")
                    metric(title: "体脂肪率", value: record.bodyFatPercentage, unit: "%")
                    metric(
                        title: "測定日",
                        text: record.date.formatted(.dateTime.year().month().day())
                    )
                }
            } else {
                Text("記録がありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 80)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }

    private func metric(title: String, value: Double, unit: String) -> some View {
        metric(title: title, text: String(format: "%.1f%@", value, unit))
    }

    private func metric(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.subheadline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
