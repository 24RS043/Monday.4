import SwiftUI

struct MuscleBalanceCardView: View {
    let logs: [WorkoutLog]

    private var balances: [(name: String, value: Double)] {
        let recentLogs = logs.filter {
            guard let days = Calendar.current.dateComponents([.day], from: $0.date, to: .now).day else {
                return false
            }
            return days >= 0 && days < 7
        }

        let chest = score(for: recentLogs, keywords: ["ベンチ", "腕立て", "プレス"])
        let back = score(for: recentLogs, keywords: ["懸垂", "ラット", "ロウ"])
        let legs = score(for: recentLogs, keywords: ["スクワット", "レッグ", "デッド"])
        let shoulders = score(for: recentLogs, keywords: ["ショルダー"])
        let arms = score(for: recentLogs, keywords: ["カール", "腕"])
        let maxScore = [chest, back, legs, shoulders, arms, 1].max() ?? 1

        return [
            ("胸", Double(chest) / Double(maxScore)),
            ("背中", Double(back) / Double(maxScore)),
            ("脚", Double(legs) / Double(maxScore)),
            ("肩", Double(shoulders) / Double(maxScore)),
            ("腕", Double(arms) / Double(maxScore))
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("今週の部位バランス")
                .font(.headline)

            ForEach(balances, id: \.name) { item in
                HStack(spacing: 10) {
                    Text(item.name)
                        .font(.caption)
                        .frame(width: 32, alignment: .leading)

                    ProgressView(value: item.value)
                        .tint(.blue)

                    Text("\(Int(item.value * 100))%")
                        .font(.caption)
                        .frame(width: 38, alignment: .trailing)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }

    private func score(for logs: [WorkoutLog], keywords: [String]) -> Int {
        logs
            .filter { log in
                keywords.contains { keyword in
                    log.exerciseName.contains(keyword)
                }
            }
            .reduce(0) { $0 + $1.sets }
    }
}
