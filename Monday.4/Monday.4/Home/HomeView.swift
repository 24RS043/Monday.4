import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \WorkoutLog.date, order: .reverse)
    private var workoutLogs: [WorkoutLog]

    @Query(sort: \InBodyRecord.date, order: .forward)
    private var inBodyRecords: [InBodyRecord]

    @Query(sort: \WorkoutDay.date, order: .reverse)
    private var workoutDays: [WorkoutDay]

    @Query(sort: \UserProfile.name)
    private var profiles: [UserProfile]

    @State private var selectedDate = Date()
    @State private var path = NavigationPath()

    private let dailyTrainingMinuteGoal = 60.0
    private let dailyCalorieGoal = 500.0
    private let dailySetGoal = 20
    private let weeklyTrainingDayGoal = 5

    private var profile: UserProfile? {
        profiles.first
    }

    private var todayLogs: [WorkoutLog] {
        workoutLogs.filter { Calendar.current.isDateInToday($0.date) }
    }

    private var todaySetCount: Int {
        todayLogs.reduce(0) { $0 + $1.sets }
    }

    private var todayTrainingMinutes: Double {
        Double(todaySetCount) * 2.5
    }

    private var todayCalories: Double {
        Double(todaySetCount) * 12.0
    }

    private var thisMonthCount: Int {
        workoutDays.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }.count
    }

    private var totalWorkoutCount: Int {
        workoutDays.count
    }

    private var weeklyTrainingDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let days = workoutDays.compactMap { item -> Date? in
            let day = calendar.startOfDay(for: item.date)
            guard let difference = calendar.dateComponents([.day], from: day, to: today).day,
                  difference >= 0,
                  difference < 7
            else {
                return nil
            }
            return day
        }

        return Set(days).count
    }

    private var streak: Int {
        let calendar = Calendar.current
        let uniqueDays = Set(workoutDays.map { calendar.startOfDay(for: $0.date) })
        var current = calendar.startOfDay(for: Date())
        var count = 0

        while uniqueDays.contains(current) {
            count += 1

            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: current) else {
                break
            }

            current = previousDay
        }

        return count
    }

    private var selectedDateRecorded: Bool {
        workoutDays.contains {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 18) {
                    headerView

                    CalendarOverviewCardView(
                        selectedDate: $selectedDate,
                        thisMonthCount: thisMonthCount,
                        streak: streak,
                        totalWorkoutCount: totalWorkoutCount,
                        isSelectedDateRecorded: selectedDateRecorded,
                        onRecord: { recordWorkoutDay(for: selectedDate) },
                        onOpenCalendar: { path.append(HomeRoute.calendar) }
                    )

                    summaryGrid

                    GoalWeightCardView(
                        targetWeight: profile?.targetWeight,
                        latestWeight: inBodyRecords.last?.weight,
                        onOpenProfile: { path.append(HomeRoute.profile) }
                    )

                    LatestInBodyCardView(
                        record: inBodyRecords.last,
                        onShowHistory: { path.append(HomeRoute.inBodyHistory) }
                    )

                    WeeklyActivityCardView(days: workoutDays)

                    BodyPredictionHomeCard(
                        records: inBodyRecords,
                        onTap: { path.append(HomeRoute.inBodyHistory) }
                    )

                    GoalInsightCardView(
                        todayCalories: todayCalories,
                        calorieGoal: dailyCalorieGoal,
                        todaySets: todaySetCount,
                        setGoal: dailySetGoal,
                        weeklyTrainingDays: weeklyTrainingDays
                    )

                    SmallWeightCardView(records: inBodyRecords)

                    MuscleBalanceCardView(logs: workoutLogs)

                    RecentWorkoutCardView(
                        logs: workoutLogs,
                        onShowAll: { path.append(HomeRoute.workoutHistory) }
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .navigationDestination(for: HomeRoute.self) { route in
                destination(for: route)
            }
        }
    }

    private var headerView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(Date.now.formatted(date: .complete, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("おはよう、\(displayName) 👋")
                    .font(.system(size: 26, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text("今日もいい一日にしよう！")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 10) {
                CircleIconButton(
                    systemName: "bell",
                    accessibilityLabel: "通知",
                    action: { path.append(HomeRoute.notifications) }
                )

                CircleIconButton(
                    systemName: "person",
                    accessibilityLabel: "プロフィール",
                    action: { path.append(HomeRoute.profile) }
                )
            }
        }
    }

    private var summaryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            HomeSummaryCardView(
                icon: "clock.fill",
                iconColor: .purple,
                title: "今日のトレーニング",
                value: "\(Int(todayTrainingMinutes))",
                unit: "分",
                goalText: "目標 \(Int(dailyTrainingMinuteGoal))分",
                progress: progress(todayTrainingMinutes, dailyTrainingMinuteGoal)
            )

            HomeSummaryCardView(
                icon: "flame.fill",
                iconColor: .orange,
                title: "消費カロリー",
                value: "\(Int(todayCalories))",
                unit: "kcal",
                goalText: "目標 \(Int(dailyCalorieGoal))kcal",
                progress: progress(todayCalories, dailyCalorieGoal)
            )

            HomeSummaryCardView(
                icon: "dumbbell.fill",
                iconColor: .green,
                title: "セット数",
                value: "\(todaySetCount)",
                unit: "セット",
                goalText: "目標 \(dailySetGoal)セット",
                progress: progress(Double(todaySetCount), Double(dailySetGoal))
            )

            HomeSummaryCardView(
                icon: "calendar",
                iconColor: .blue,
                title: "今週の運動日数",
                value: "\(weeklyTrainingDays)",
                unit: "日",
                goalText: "目標 \(weeklyTrainingDayGoal)日",
                progress: progress(Double(weeklyTrainingDays), Double(weeklyTrainingDayGoal))
            )
        }
    }

    private var displayName: String {
        guard let name = profile?.name.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty
        else {
            return "ユーザー"
        }

        return name
    }

    private func recordWorkoutDay(for date: Date) {
        let day = Calendar.current.startOfDay(for: date)

        guard !workoutDays.contains(where: {
            Calendar.current.isDate($0.date, inSameDayAs: day)
        }) else {
            return
        }

        modelContext.insert(WorkoutDay(date: day))
        try? modelContext.save()
    }

    private func progress(_ value: Double, _ goal: Double) -> Double {
        guard goal > 0 else { return 0 }
        return min(max(value / goal, 0), 1)
    }

    @ViewBuilder
    private func destination(for route: HomeRoute) -> some View {
        switch route {
        case .notifications:
            HomeNotificationsView()
        case .profile:
            HomeProfileSummaryView(
                profile: profile,
                latestRecord: inBodyRecords.last
            )
        case .calendar:
            HomeWorkoutCalendarView(days: workoutDays)
        case .inBodyHistory:
            HomeInBodyHistoryView(records: inBodyRecords)
        case .workoutHistory:
            HomeWorkoutHistoryView(logs: workoutLogs)
        }
    }
}

#Preview {
    HomeView()
}
