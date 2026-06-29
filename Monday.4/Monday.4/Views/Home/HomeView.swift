import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerView

                    todaySummarySection

                    InBodyPredictionChartCard()

                    recentRecordSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("おはよう、Haruto 👋")
                    .font(.title2.bold())

                Text("今日もいい一日にしよう！")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                // 通知画面など
            } label: {
                Image(systemName: "bell")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 8)
    }

    private var todaySummarySection: some View {
        HStack(spacing: 12) {
            SummaryCardView(
                icon: "clock.fill",
                iconColor: .purple,
                title: "今日のトレーニング",
                value: "45",
                unit: "分",
                target: "目標 60分",
                progress: 0.75
            )

            SummaryCardView(
                icon: "flame.fill",
                iconColor: .orange,
                title: "消費カロリー",
                value: "420",
                unit: "kcal",
                target: "目標 500kcal",
                progress: 0.84
            )

            SummaryCardView(
                icon: "dumbbell.fill",
                iconColor: .green,
                title: "セット数",
                value: "18",
                unit: "セット",
                target: "目標 20セット",
                progress: 0.9
            )
        }
    }

    private var recentRecordSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近の記録")
                .font(.headline)

            VStack(spacing: 12) {
                RecentWorkoutRowView(
                    title: "胸トレーニング",
                    subtitle: "ベンチプレス / ダンベルプレス",
                    time: "45分"
                )

                RecentWorkoutRowView(
                    title: "背中トレーニング",
                    subtitle: "ラットプルダウン / ロウ",
                    time: "50分"
                )
            }
        }
    }
}
