import SwiftUI

struct GoalInsightCardView: View {
    let todayCalories: Double
    let calorieGoal: Double
    let todaySets: Int
    let setGoal: Int
    let weeklyTrainingDays: Int

    private var message: String {
        if todaySets >= setGoal {
            return "今日のセット目標は達成しています。無理せず休養も意識しましょう。"
        }

        let remainingSets = max(setGoal - todaySets, 0)

        if weeklyTrainingDays == 0 {
            return "今週はまだ記録がありません。まずは軽めに\(remainingSets)セットを目標に始めましょう。"
        }

        if todayCalories >= calorieGoal {
            return "今日の消費カロリー目標は達成しています。フォームを崩さず安全に続けましょう。"
        }

        return "今日の目標まであと\(remainingSets)セットです。短めのメニューでも記録すると継続しやすくなります。"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(.yellow)
                .frame(width: 42, height: 42)
                .background(.yellow.opacity(0.16))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text("今日のアドバイス")
                    .font(.headline)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
            }

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 7)
    }
}
