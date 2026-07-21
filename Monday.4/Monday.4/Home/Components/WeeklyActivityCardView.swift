import SwiftUI

struct WeeklyActivityCardView: View {
    let days: [WorkoutDay]

    private let symbols = ["月", "火", "水", "木", "金", "土", "日"]

    private var completedDays: Set<Int> {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return Set(
            days.compactMap { item in
                let day = calendar.startOfDay(for: item.date)

                guard let difference = calendar.dateComponents([.day], from: day, to: today).day,
                      difference >= 0,
                      difference < 7
                else {
                    return nil
                }

                let weekday = calendar.component(.weekday, from: day)
                return weekday == 1 ? 6 : weekday - 2
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("今週のアクティビティ")
                    .font(.headline)

                Spacer()

                Text("\(completedDays.count) / 7日")
                    .font(.title3.bold())
                    .foregroundStyle(.green)
            }

            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { index in
                    VStack(spacing: 8) {
                        Text(symbols[index])
                            .font(.caption.bold())

                        Circle()
                            .stroke(
                                completedDays.contains(index) ? .green : Color.gray.opacity(0.16),
                                lineWidth: 6
                            )
                            .frame(width: 28, height: 28)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}
