import SwiftUI

struct RecentWorkoutCardView: View {
    let logs: [WorkoutLog]
    let onShowAll: () -> Void

    private var recentLogs: [WorkoutLog] {
        Array(logs.prefix(3))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("直近の筋トレ")
                    .font(.headline)

                Spacer()

                Button("すべて見る", action: onShowAll)
                    .font(.caption.bold())
            }

            if recentLogs.isEmpty {
                Text("記録がありません")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 80)
            } else {
                ForEach(Array(recentLogs.enumerated()), id: \.offset) { _, log in
                    RecentWorkoutRowView(
                        title: log.exerciseName,
                        subtitle: "\(weightText(log.weight))・\(log.reps)回 × \(log.sets)セット",
                        time: log.date.formatted(.dateTime.month().day())
                    )
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }

    private func weightText(_ weight: Double?) -> String {
        guard let weight else {
            return "重量未設定"
        }

        return "\(weight.formatted(.number.precision(.fractionLength(1))))kg"
    }
}
