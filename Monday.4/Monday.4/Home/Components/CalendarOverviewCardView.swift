import SwiftUI

struct CalendarOverviewCardView: View {
    @Binding var selectedDate: Date

    let thisMonthCount: Int
    let streak: Int
    let totalWorkoutCount: Int
    let isSelectedDateRecorded: Bool
    let onRecord: () -> Void
    let onOpenCalendar: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Label("カレンダー", systemImage: "calendar")
                    .font(.headline)

                Spacer()

                Button(action: onOpenCalendar) {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("カレンダー詳細")
            }

            DatePicker(
                "日付",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()

            Divider()

            HStack {
                stat(icon: "figure.strengthtraining.traditional", value: thisMonthCount, title: "今月")
                Spacer()
                stat(icon: "flame.fill", value: streak, title: "連続")
                Spacer()
                stat(icon: "trophy.fill", value: totalWorkoutCount, title: "累計")
            }

            Button(action: onRecord) {
                Label(
                    isSelectedDateRecorded ? "この日は記録済み" : "選択した日にジムへ行った！",
                    systemImage: isSelectedDateRecorded ? "checkmark.circle.fill" : "figure.strengthtraining.traditional"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSelectedDateRecorded)
        }
        .padding(18)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 7)
    }

    private func stat(icon: String, value: Int, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)

            Text("\(value)")
                .font(.title2.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
