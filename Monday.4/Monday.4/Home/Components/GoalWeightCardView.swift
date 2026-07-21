import SwiftUI

struct GoalWeightCardView: View {
    let targetWeight: Double?
    let latestWeight: Double?
    let onOpenProfile: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("目標体重", systemImage: "target")
                    .font(.headline)

                Spacer()

                Button(action: onOpenProfile) {
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("プロフィールを開く")
            }

            if let targetWeight {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", targetWeight))
                        .font(.system(size: 34, weight: .bold))

                    Text("kg")
                        .foregroundStyle(.secondary)
                }

                if let latestWeight {
                    let difference = latestWeight - targetWeight

                    Text("現在 \(latestWeight, specifier: "%.1f")kg")
                        .font(.subheadline)

                    if difference > 0 {
                        Text("目標まであと \(difference, specifier: "%.1f")kg")
                            .font(.subheadline.bold())
                            .foregroundStyle(.orange)
                    } else {
                        Text("目標を達成しました 🎉")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    }
                } else {
                    Text("InBody記録を追加すると現在値との差が表示されます")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("プロフィールで目標体重を設定してください")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}
