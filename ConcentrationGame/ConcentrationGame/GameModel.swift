import Foundation

final class GameModel {
    let id: Int
    let emojy: String
    var isAlwayesOpened = false
    
    init(id: Int, emojy: String) {
        self.id = id
        self.emojy = emojy
    }
    
    func copy() -> GameModel {
        return GameModel(id: id, emojy: emojy)
    }
}

extension GameModel: Equatable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }
}
