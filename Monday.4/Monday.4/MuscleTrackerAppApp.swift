import SwiftUI
import SwiftData

@main
struct MuscleTrackerAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([WorkoutLog.self, InBodyRecord.self, GymEquipment.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainerの作成に失敗: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
