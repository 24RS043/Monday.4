import SwiftUI

struct TodayAdviceCardView: View {
    let todaySets: Int
    let setGoal: Int

    private var message: String {
        if todaySets <= 0 {
            return "今日はまだ筋トレ記録がありません。まずは1種目だけでも記録してみましょう。"
        }

        if todaySets >= setGoal {
            return "今日のセット目標は達成しています。無理せず休養も意識しましょう。"
        }

        let remaining = setGoal - todaySets
        return "今日の目標まであと\(remaining)セットです。短めのメニューでも続けることが大切です。"
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(.yellow)
                .frame(width: 42, height: 42)
                .background(.yellow.opacity(0.18))
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}
