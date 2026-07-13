//
//  HomeView.swift
//  Monday.4
//
//  Created by Morimoto Taketo on 2026/06/15.
//

//
//  HomeView.swift
//  Monday.4
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext)
    private var modelContext

    @Query(sort: \WorkoutLog.date, order: .reverse)
    private var workoutLogs: [WorkoutLog]

    @Query(sort: \InBodyRecord.date, order: .reverse)
    private var inBodyRecords: [InBodyRecord]

    @Query(sort: \WorkoutDay.date, order: .reverse)
    private var workoutDays: [WorkoutDay]

    @Query(sort: \UserProfile.name)
    private var profiles: [UserProfile]

    @State private var selectedDate = Date()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    // 今日の日付
                    VStack {

                        Text(Date.now.formatted(date: .complete, time: .omitted))
                            .font(.title2)
                            .bold()

                    }

                    // カレンダー
                    GroupBox("📅 カレンダー") {

                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)

                        Divider()

                        HStack {

                            VStack {

                                Text("🏋️")
                                    .font(.largeTitle)

                                Text("\(thisMonthCount)")
                                    .font(.title2)
                                    .bold()

                                Text("今月")

                            }

                            Spacer()

                            VStack {

                                Text("🔥")
                                    .font(.largeTitle)

                                Text("\(streak)")
                                    .font(.title2)
                                    .bold()

                                Text("連続")

                            }

                            Spacer()

                            VStack {

                                Text("🏆")
                                    .font(.largeTitle)

                                Text("\(totalWorkoutCount)")
                                    .font(.title2)
                                    .bold()

                                Text("累計")

                            }

                        }

                    }

                    // 今日ジム
                    Button {

                        let today = Calendar.current.startOfDay(for: Date())

                        let already = workoutDays.contains {

                            Calendar.current.isDate(
                                $0.date,
                                inSameDayAs: today
                            )

                        }

                        if !already {

                            modelContext.insert(
                                WorkoutDay(date: today)
                            )

                        }

                    } label: {

                        Label(
                            "今日ジムに行った！",
                            systemImage: "figure.strengthtraining.traditional"
                        )
                        .frame(maxWidth: .infinity)

                    }
                    .buttonStyle(.borderedProminent)

                    // 目標
                    GroupBox("🎯 目標") {

                        VStack(alignment: .leading, spacing: 8) {

                            if let profile = profiles.first {

                                Text("目標体重")
                                    .font(.headline)

                                Text("\(profile.targetWeight ?? 0, specifier: "%.1f")kg")
                                    .font(.title)

                                if let latest = inBodyRecords.first,
                                   let target = profile.targetWeight {

                                    Text("現在 \(latest.weight, specifier: "%.1f")kg")

                                    let diff = latest.weight - target

                                    if diff > 0 {

                                        Text("あと \(diff, specifier: "%.1f")kg")

                                    } else {

                                        Text("達成しました🎉")

                                    }

                                }

                            } else {

                                Text("プロフィールを設定してください")

                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    // 最新InBody
                    latestInBody

                    // 直近の筋トレ
                    GroupBox("💪 直近の筋トレ") {

                        if let latestWorkout = workoutLogs.first {

                            VStack(alignment: .leading, spacing: 8) {

                                Text(latestWorkout.exerciseName)
                                    .font(.headline)

                                Text("重量 : \(latestWorkout.weight, specifier: "%.1f")kg")

                                Text("\(latestWorkout.reps)回 × \(latestWorkout.sets)セット")

                                Text(latestWorkout.date.formatted(
                                    date: .abbreviated,
                                    time: .omitted
                                ))
                                .foregroundStyle(.secondary)

                            }

                        } else {

                            Text("記録がありません")

                        }

                    }

                }
                .padding()

            }
            .navigationTitle("ホーム")

        }

    }

    // MARK: - 今月のトレーニング回数
    private var thisMonthCount: Int {

        let calendar = Calendar.current

        return workoutDays.filter {

            calendar.isDate(
                $0.date,
                equalTo: Date(),
                toGranularity: .month
            )

        }.count

    }

    // MARK: - 累計回数
    private var totalWorkoutCount: Int {

        workoutDays.count

    }

    // MARK: - 連続日数
    private var streak: Int {

        let calendar = Calendar.current

        let uniqueDays = Set(
            workoutDays.map {
                calendar.startOfDay(for: $0.date)
            }
        )

        var current = calendar.startOfDay(for: Date())
        var count = 0

        while uniqueDays.contains(current) {

            count += 1

            guard let yesterday = calendar.date(
                byAdding: .day,
                value: -1,
                to: current
            ) else {
                break
            }

            current = yesterday

        }

        return count

    }

}

extension HomeView {

    var latestInBody: some View {

        GroupBox("📊 最新InBody") {

            if let latest = inBodyRecords.first {

                VStack(alignment: .leading, spacing: 8) {

                    Text("体重 : \(latest.weight, specifier: "%.1f")kg")

                    Text("筋肉量 : \(latest.muscleMass, specifier: "%.1f")kg")

                    Text("体脂肪量 : \(latest.bodyFatMass, specifier: "%.1f")kg")

                    Text("BMI : \(latest.bmi, specifier: "%.1f")")

                    Text("体脂肪率 : \(latest.bodyFatPercentage, specifier: "%.1f")%")

                }

            } else {

                Text("記録がありません")

            }

        }

    }

}

#Preview {
    HomeView()
}
