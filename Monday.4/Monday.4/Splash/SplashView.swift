import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundStyle(.blue)

                Text("Muscle Tracker")
                    .font(.largeTitle.bold())

                Text("今日の成長を記録しよう")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ProgressView()
                    .padding(.top, 12)
            }
        }
    }
}
