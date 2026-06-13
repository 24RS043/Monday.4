import Foundation
import SwiftData

@Model
final class GymEquipment {
    var id: UUID
    var name: String
    var memo: String?
    var positionX: Double
    var positionY: Double

    init(id: UUID = UUID(), name: String, memo: String? = nil, positionX: Double, positionY: Double) {
        self.id = id
        self.name = name
        self.memo = memo
        self.positionX = positionX
        self.positionY = positionY
    }
}
