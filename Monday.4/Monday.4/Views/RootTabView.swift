import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            WorkoutView()
                .tabItem { Label("筋トレ記録", systemImage: "dumbbell") }
            InBodyScanView()
                .tabItem { Label("InBody", systemImage: "camera.viewfinder") }
            GymMapView()
                .tabItem { Label("ジムマップ", systemImage: "map") }
        }
    }
}
