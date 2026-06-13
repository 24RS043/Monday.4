import SwiftUI

struct RootTabView: View {
    var body: some View {
        
        
        TabView {
            WorkoutView()
                .tabItem { Label("筋トレ記録", systemImage: "dumbbell") }
            InBodyScanView()
                .tabItem { Label("InBody", systemImage: "camera.viewfinder") }
            CalendarView()
                .tabItem { Label("カレンダー", systemImage: "calendar") }
            GymMapView()
                .tabItem { Label("ジムマップ", systemImage: "map") }
        }
    }
}
