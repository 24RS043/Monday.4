import SwiftUI
import SwiftData
 
struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
 
    @Query(sort: \WorkoutLog.date, order: .reverse)
    private var logs: [WorkoutLog]
 
    @Query
    private var goals: [Goal]
 
    @State private var selectedExercise = DefaultExercises.list.first ?? ""
 
    @State private var weightText = ""
    @State private var repsText = ""
    @State private var setsText = "3"
 
    @State private var targetWeightText = ""
 
    var body: some View {
        NavigationStack {
            Form {
 
                // MARK: - 目標設定
                Section("目標設定") {
 
                    Picker("種目", selection: $selectedExercise) {
                        ForEach(DefaultExercises.list, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
 
                    TextField("目標重量(kg)", text: $targetWeightText)
                        .keyboardType(.decimalPad)
 
                    Button("目標保存") {
 
                        guard let target = Double(targetWeightText) else {
                            return
                        }
 
                        let goal = Goal(
                            exerciseName: selectedExercise,
                            targetWeight: target
                        )
 
                        modelContext.insert(goal)
 
                        targetWeightText = ""
                    }
 
                    if let goal = goals.first(where: {
                        $0.exerciseName == selectedExercise
                    }) {
 
                        Text("目標: \(goal.targetWeight, specifier: "%.1f")kg")
                            .foregroundStyle(.blue)
 
                        let progress = personalBest / goal.targetWeight * 100
 
                        Text("達成率: \(progress, specifier: "%.0f")%")
                            .foregroundStyle(.green)
                    }
                }
 
                // MARK: - 記録追加
                Section("記録を追加") {
 
                    Text("自己ベスト: \(personalBest, specifier: "%.1f")kg")
                        .foregroundStyle(.orange)
                        .font(.headline)
 
                    Picker("種目", selection: $selectedExercise) {
                        ForEach(DefaultExercises.list, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
 
                    HStack {
                        TextField("重量(kg)", text: $weightText)
                            .keyboardType(.decimalPad)
 
                        TextField("回数", text: $repsText)
                            .keyboardType(.numberPad)
 
                        TextField("セット数", text: $setsText)
                            .keyboardType(.numberPad)
                    }
 
                    Button("追加") {
                        addLog()
                    }
                    .disabled(
                        weightText.isEmpty ||
                        repsText.isEmpty ||
                        setsText.isEmpty
                    )
                }
 
                // MARK: - 履歴
                Section("履歴") {
 
                    ForEach(logs) { log in
 
                        VStack(alignment: .leading) {
 
                            Text(log.exerciseName)
                                .font(.headline)
 
                            Text(
                                "\(log.weight, specifier: "%.1f")kg × \(log.reps)reps × \(log.sets)sets"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        for i in offsets {
                            modelContext.delete(logs[i])
                        }
                    }
                }
            }
            .navigationTitle("筋トレ記録")
        }
    }
 
    // MARK: - 自己ベスト
    private var personalBest: Double {
        logs
            .filter { $0.exerciseName == selectedExercise }
            .map { $0.weight }
            .max() ?? 0
    }
 
    // MARK: - 記録保存
    private func addLog() {
 
        guard
            let weight = Double(weightText),
            let reps = Int(repsText),
            let sets = Int(setsText)
        else {
            return
        }
 
        modelContext.insert(
            WorkoutLog(
                exerciseName: selectedExercise,
                weight: weight,
                reps: reps,
                sets: sets
            )
        )
 
        weightText = ""
        repsText = ""
        setsText = "3"
    }
}
