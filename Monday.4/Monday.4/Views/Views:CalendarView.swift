import SwiftUI
import SwiftData

/// カレンダーから日付を選んで、その日の記録を確認する画面
struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workoutLogs: [WorkoutLog]
    @Query private var inBodyRecords: [InBodyRecord]

    @State private var selectedDate: Date = .now
    @State private var displayedMonth: Date = .now

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                monthHeader

                let days = generateDays(for: displayedMonth)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { w in
                        Text(w)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    ForEach(days, id: \.self) { date in
                        if let date {
                            dayCell(for: date)
                        } else {
                            Color.clear.frame(height: 36)
                        }
                    }
                }
                .padding(.horizontal)

                Divider()
                    .padding(.vertical, 8)

                List {
                    Section("筋トレ記録") {
                        let logs = workoutLogs.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                        if logs.isEmpty {
                            Text("記録なし").foregroundStyle(.secondary)
                        } else {
                            ForEach(logs) { log in
                                VStack(alignment: .leading) {
                                    Text(log.exerciseName).font(.headline)
                                    Text("\(log.weight, specifier: "%.1f")kg × \(log.reps)reps × \(log.sets)sets")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    Section("InBody記録") {
                        let records = inBodyRecords.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                        if records.isEmpty {
                            Text("記録なし").foregroundStyle(.secondary)
                        } else {
                            ForEach(records) { record in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("体重 \(record.weight, specifier: "%.1f")kg / 筋肉量 \(record.muscleMass, specifier: "%.1f")kg")
                                    Text("体脂肪量 \(record.bodyFatMass, specifier: "%.1f")kg / BMI \(record.bmi, specifier: "%.1f") / 体脂肪率 \(record.bodyFatPercentage, specifier: "%.1f")%")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("カレンダー")
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(displayedMonth.formatted(.dateTime.year().month()))
                .font(.headline)

            Spacer()

            Button {
                displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)
        let hasRecord = hasAnyRecord(on: date)

        return Button {
            selectedDate = date
        } label: {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.body)
                    .frame(width: 32, height: 32)
                    .background(isSelected ? Color.accentColor : Color.clear)
                    .foregroundStyle(isSelected ? .white : (isToday ? Color.accentColor : .primary))
                    .clipShape(Circle())

                Circle()
                    .fill(hasRecord ? Color.accentColor : .clear)
                    .frame(width: 5, height: 5)
            }
        }
        .buttonStyle(.plain)
    }

    private func hasAnyRecord(on date: Date) -> Bool {
        workoutLogs.contains { calendar.isDate($0.date, inSameDayAs: date) } ||
        inBodyRecords.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    /// 指定月の日付配列を生成(月初の曜日に合わせてnilで埋める)
    private func generateDays(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) // 1=日曜
        let leadingEmptyDays = firstWeekday - 1

        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: [WorkoutLog.self, InBodyRecord.self], inMemory: true)
}
