import SwiftUI
import SwiftData

struct SettingsView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    var body: some View {

        NavigationStack {

            List {

                Section("プロフィール") {

                    if let profile = profiles.first {

                        NavigationLink {
                            ProfileView(profile: profile)
                        } label: {
                            Label("身体情報", systemImage: "person.fill")
                        }

                    } else {

                        Button {

                            let profile = UserProfile()
                            modelContext.insert(profile)

                        } label: {

                            Label("プロフィールを作成", systemImage: "person.badge.plus")

                        }

                    }

                }

            }
            .navigationTitle("設定")
            .onAppear {

                if profiles.isEmpty {
                    modelContext.insert(UserProfile())
                }

            }

        }

    }
}

#Preview {
    SettingsView()
}
