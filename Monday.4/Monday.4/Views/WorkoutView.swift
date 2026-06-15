import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutLog.date, order: .reverse) private var logs: [WorkoutLog]

    @State private var selectedExercise = DefaultExercises.list.first ?? ""
    @State private var weightText = ""
    @State private var repsText = ""
    @State private var setsText = "3"

    var body: some View {
        NavigationStack {
            Form {
                Section("記録を追加") {
                    Picker("種目", selection: $selectedExercise) {
                        ForEach(DefaultExercises.list, id: \.self) { Text($0).tag($0) }
                    }
                    HStack {
                        TextField("重量(kg)", text: $weightText).keyboardType(.decimalPad)
                        TextField("回数", text: $repsText).keyboardType(.numberPad)
                        TextField("セット数", text: $setsText).keyboardType(.numberPad)
                    }
                    Button("追加") { addLog() }
                        .disabled(weightText.isEmpty || repsText.isEmpty || setsText.isEmpty)
                }
                Section("履歴") {
                    ForEach(logs) { log in
                        VStack(alignment: .leading) {
                            Text(log.exerciseName).font(.headline)
                            Text("\(log.weight, specifier: "%.1f")kg × \(log.reps)reps × \(log.sets)sets")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        for i in offsets { modelContext.delete(logs[i]) }
                    }
                }
            }
            .navigationTitle("筋トレ記録")
        }
        .hideKeyboardOnTap()
    }

    private func addLog() {
        guard let weight = Double(weightText), let reps = Int(repsText), let sets = Int(setsText) else { return }
        modelContext.insert(WorkoutLog(exerciseName: selectedExercise, weight: weight, reps: reps, sets: sets))
        weightText = ""; repsText = ""; setsText = "3"
    }
}
