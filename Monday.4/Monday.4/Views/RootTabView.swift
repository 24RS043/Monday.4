import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }

            WorkoutView()
                .tabItem {
                    Label("筋トレ", systemImage: "dumbbell")
                }

            InBodyScanView()
                .tabItem {
                    Label("InBody", systemImage: "camera.viewfinder")
                }


            GymMapView()
                .tabItem {
                    Label("ジム", systemImage: "map")
                }
        }
    }
}
