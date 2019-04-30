import Foundation

//enum ConcentrationState {
//    case start
//    case wrongPaire
//    case selection
//    case finished
//}

/// for novice
/// https://habr.com/ru/company/skillbox/blog/447598/
/// https://github.com/Xiomara7/Memory

protocol GameDelegate: class {
    func closeCells(at indexPathes: [IndexPath])
    func openCell(at indexPath: IndexPath)
    func gameDidFinished()
}

final class Game {
    
    weak var delegate: GameDelegate?
    
    var raws: Int = 0
    var collumns: Int = 0
    
    var gameModels = [GameModel]()
    
    func start(raws: Int, collumns: Int) {
        self.raws = raws
        self.collumns = collumns
        
        let totalCells = raws * collumns
        if totalCells % 2 == 1 {
            assertionFailure("should be even number of cards")
            return
        }
        let createCellsCount = totalCells / 2
        
        var emojies = [String]()
        while emojies.count < createCellsCount {
            guard let randomEmojy = Emoji.shared.emojiCategories["people"]?.randomElement() else {
                assertionFailure()
                return
            }
            if !emojies.contains(randomEmojy) {
                emojies.append(randomEmojy)
            }
        }
        
        assert(emojies.count == createCellsCount)
        
        gameModels = emojies.enumerated().map { GameModel(id: $0.offset, emojy: $0.element) }
        //gameModels = emojies.map { GameModel(id: UUID().uuidString, emojy: $0) }
        
        gameModels += gameModels
        gameModels.shuffle()
        
        assert(gameModels.count == totalCells)
    }
    
    var openedCount = 0
    var isFinished = false
    
    
    private var lastSelectedIndexPath: IndexPath?
    
    private var indexPathesToClose = [IndexPath]()
    
    /// close wrong cards
    private func closeCellsIfNeed() {
        if !indexPathesToClose.isEmpty {
            delegate?.closeCells(at: indexPathesToClose)
            indexPathesToClose.removeAll()
//            indexPathesToClose.forEach({ gameModels[$0.item].isAlwayesOpened = false })
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        if isFinished {
            return
        }
        
        if lastSelectedIndexPath == indexPath {
            return
        }
        
        let selectedModel = gameModels[indexPath.row]
        if selectedModel.isAlwayesOpened {
            return
        }
        
        closeCellsIfNeed()
        
        if let lastSelectedIndexPath = lastSelectedIndexPath {
            let lastSelectedModel = gameModels[lastSelectedIndexPath.row]
            
            if selectedModel == lastSelectedModel {
                selectedModel.isAlwayesOpened = true
                lastSelectedModel.isAlwayesOpened = true
                openedCount += 2
                
                if openedCount == gameModels.count {
                    isFinished = true
                    delegate?.gameDidFinished()
                }
                
            } else {
                indexPathesToClose += [indexPath, lastSelectedIndexPath]
            }
            
//            selectedModel.isAlwayesOpened = true
//            lastSelectedModel.isAlwayesOpened = true
            
            self.lastSelectedIndexPath = nil
        } else {
            self.lastSelectedIndexPath = indexPath
        }
        
        delegate?.openCell(at: indexPath)
    }
}

final class GameModel {
    let id: Int
    let emojy: String
    var isAlwayesOpened = false
    
    init(id: Int, emojy: String) {
        self.id = id
        self.emojy = emojy
    }
}

extension GameModel: Equatable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }
}
