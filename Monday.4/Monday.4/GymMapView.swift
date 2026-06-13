import SwiftUI
import SwiftData

struct GymMapView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var equipments: [GymEquipment]
    @State private var isAddingPin = false
    @State private var newPinPosition: CGPoint?
    @State private var newPinName = ""

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Image("gym_map").resizable().scaledToFit()
                    ForEach(equipments) { eq in
                        VStack {
                            Image(systemName: "mappin.circle.fill").foregroundStyle(.red)
                            Text(eq.name).font(.caption2)
                        }
                        .position(x: eq.positionX * geo.size.width, y: eq.positionY * geo.size.height)
                    }
                }
                .onTapGesture { loc in if isAddingPin { newPinPosition = loc } }
                .overlay(alignment: .bottom) {
                    if isAddingPin, let pos = newPinPosition {
                        VStack {
                            TextField("機材名", text: $newPinName).textFieldStyle(.roundedBorder)
                            Button("ここに追加") { addPin(at: pos, in: geo.size) }
                        }.padding().background(.regularMaterial)
                    }
                }
            }
            .navigationTitle("ジムマップ")
            .toolbar {
                Button(isAddingPin ? "完了" : "ピン追加") { isAddingPin.toggle() }
            }
        }
    }

    private func addPin(at point: CGPoint, in size: CGSize) {
        modelContext.insert(GymEquipment(name: newPinName, positionX: point.x/size.width, positionY: point.y/size.height))
        newPinName = ""; newPinPosition = nil; isAddingPin = false
    }
}
