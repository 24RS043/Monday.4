//
//  HomeView.swift
//  Monday.4
//
//  Created by Morimoto Taketo on 2026/06/15.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Query(sort: \WorkoutLog.date, order: .reverse)
    private var workoutLogs: [WorkoutLog]

    @Query(sort: \InBodyRecord.date, order: .reverse)
    private var inBodyRecords: [InBodyRecord]
    
    @State private var selectedDate = Date()
    
    @Environment(\.modelContext)
    private var modelContext

    @Query
    private var gymVisits: [GymVisit]

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
                    //カレンダー
                    GroupBox("📅 カレンダー") {

                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)

                    }

                    // 最新InBody

                    GroupBox("📊 最新InBody") {

                        if let latest = inBodyRecords.first {

                            VStack(alignment: .leading) {

                                Text("体重 : \(latest.weight, specifier: "%.1f")kg")
                                Text("筋肉量 : \(latest.muscleMass, specifier: "%.1f")kg")
                                Text("体脂肪率 : \(latest.bodyFatPercentage, specifier: "%.1f")%")

                            }

                        } else {

                            Text("記録がありません")

                        }

                    }

                    // 直近の筋トレ

                    GroupBox("💪 直近の筋トレ") {

                        if let latestWorkout = workoutLogs.first {

                            VStack(alignment: .leading) {

                                Text(latestWorkout.exerciseName)
                                    .font(.headline)

                                Text("\(latestWorkout.weight, specifier: "%.1f")kg")

                                Text("\(latestWorkout.reps)回 × \(latestWorkout.sets)セット")

                            }

                        } else {

                            Text("記録がありません")

                        }

                    }
                    GroupBox("🏋 ジム") {

                        Button("ジムに行った") {

                            if !visitedToday() {
                                modelContext.insert(
                                    GymVisit()
                                )
                            }

                        }
                        .buttonStyle(.borderedProminent)

                    }
                    GroupBox("📅 ジムに行った日") {

                        if gymVisits.isEmpty {

                            Text("まだ記録がありません")

                        } else {

                            ForEach(gymVisits) { visit in

                                HStack {

                                    Text(
                                        visit.date.formatted(
                                            date: .abbreviated,
                                            time: .omitted
                                        )
                                    )

                                    Spacer()

                                    Text("⭕️")

                                }

                            }

                        }

                    }


                }

                .padding()

            }

            .navigationTitle("ホーム")

        }

    }
    private func visitedToday() -> Bool {

        gymVisits.contains {

            Calendar.current.isDate(
                $0.date,
                inSameDayAs: Date()
            )

        }

    }

}

#Preview {
    HomeView()
        .modelContainer(for: [WorkoutLog.self, InBodyRecord.self], inMemory: true)
}

