import SwiftUI

struct HomeProfileSummaryView: View {
    let profile: UserProfile?
    let latestRecord: InBodyRecord?

    var body: some View {
        List {
            Section("プロフィール") {
                LabeledContent("名前", value: profile?.name ?? "未設定")

                if let targetWeight = profile?.targetWeight {
                    LabeledContent("目標体重", value: String(format: "%.1fkg", targetWeight))
                } else {
                    LabeledContent("目標体重", value: "未設定")
                }
            }

            Section("最新の体組成") {
                if let latestRecord {
                    LabeledContent("体重", value: String(format: "%.1fkg", latestRecord.weight))
                    LabeledContent("筋肉量", value: String(format: "%.1fkg", latestRecord.muscleMass))
                    LabeledContent("体脂肪率", value: String(format: "%.1f%%", latestRecord.bodyFatPercentage))
                } else {
                    Text("InBody記録がありません")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("プロフィール")
    }
}
