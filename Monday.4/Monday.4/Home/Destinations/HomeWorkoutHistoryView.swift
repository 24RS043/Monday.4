import SwiftUI

struct HomeWorkoutHistoryView: View {
    let logs: [WorkoutLog]

    var body: some View {
        Group {
            if logs.isEmpty {
                ContentUnavailableView(
                    "筋トレ記録がありません",
                    systemImage: "dumbbell",
                    description: Text("記録を追加すると履歴が表示されます。")
                )
            } else {
                List(Array(logs.enumerated()), id: \.offset) { _, log in
                    VStack(alignment: .leading, spacing: 7) {
                        Text(log.exerciseName)
                            .font(.headline)

                        Text("\(log.weight, specifier: "%.1f")kg・\(log.reps)回 × \(log.sets)セット")
                            .font(.subheadline)

                        Text(log.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("筋トレ履歴")
    }
}
