import SwiftUI

struct HomeNotificationsView: View {
    var body: some View {
        ContentUnavailableView(
            "通知はありません",
            systemImage: "bell",
            description: Text("新しい通知が届くとここに表示されます。")
        )
        .navigationTitle("通知")
    }
}
