import SwiftUI
import SwiftData

@main
struct MuscleTrackerAppApp: App {
    @State private var showSplash = true

    var sharedModelContainer: ModelContainer = {

        let schema = Schema([
            WorkoutLog.self,
            InBodyRecord.self,
            GymEquipment.self,
            Goal.self,
            UserProfile.self,
            WorkoutDay.self
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [config]
            )
        } catch {
            fatalError("ModelContainerの作成に失敗: \(error)")
        }

    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootTabView()

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(10)
                }
            }
            .animation(.easeOut(duration: 0.35), value: showSplash)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showSplash = false
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
