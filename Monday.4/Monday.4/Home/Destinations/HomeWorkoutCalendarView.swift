import SwiftUI

struct HomeWorkoutCalendarView: View {
    let days: [WorkoutDay]

    @State private var selectedDate = Date()

    private var isRecorded: Bool {
        days.contains {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            DatePicker(
                "日付",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()

            Label(
                isRecorded ? "この日はトレーニング済みです" : "この日のトレーニング記録はありません",
                systemImage: isRecorded ? "checkmark.circle.fill" : "minus.circle"
            )
            .foregroundStyle(isRecorded ? .green : .secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("トレーニングカレンダー")
        .navigationBarTitleDisplayMode(.inline)
    }
}
