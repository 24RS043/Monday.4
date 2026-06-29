import SwiftUI
import SwiftData

struct ProfileView: View {

    @Bindable var profile: UserProfile

    var body: some View {

        Form {

            Section("基本情報") {

                TextField("名前", text: $profile.name)

                Picker("性別", selection: $profile.gender) {
                    Text("未選択").tag("")
                    Text("男性").tag("男性")
                    Text("女性").tag("女性")
                }

                DatePicker(
                    "生年月日",
                    selection: $profile.birthDate,
                    displayedComponents: .date
                )

            }

            Section("身体情報") {

                TextField(
                    "身長(cm)",
                    value: $profile.height,
                    format: .number
                )
                .keyboardType(.decimalPad)

                TextField(
                    "現在体重(kg)",
                    value: $profile.weight,
                    format: .number
                )
                .keyboardType(.decimalPad)

                TextField(
                    "目標体重(kg)",
                    value: $profile.targetWeight,
                    format: .number
                )
                .keyboardType(.decimalPad)

            }

            Section("活動レベル") {

                Picker("活動量", selection: $profile.activityLevel) {
                    Text("未選択").tag("")
                    Text("低い").tag("低い")
                    Text("普通").tag("普通")
                    Text("高い").tag("高い")
                }
                .pickerStyle(.menu)

            }

        }
        .navigationTitle("身体情報")
    }
}

#Preview {
    NavigationStack {
        ProfileView(profile: UserProfile())
    }
}
