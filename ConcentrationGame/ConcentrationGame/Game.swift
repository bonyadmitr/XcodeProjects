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
    
    func start(raws: Int, collumns: Int, equalNumber: Int) {
        self.raws = raws
        self.collumns = collumns
        self.equalNumber = equalNumber
        
        let totalCells = raws * collumns
        if totalCells % equalNumber == 1 {
            assertionFailure("should be even number of cards")
            return
        }
        let createCellsCount = totalCells / equalNumber
        
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
        
        let gameModelsToCopy = emojies.enumerated().map { GameModel(id: $0.offset, emojy: $0.element) }
        gameModels = gameModelsToCopy
        
        for _ in 2...equalNumber {
            gameModels += gameModelsToCopy.map { $0.copy() }
        }
        
        
        gameModels.shuffle()
        
        assert(gameModels.count == totalCells)
    }
    
    var openedCount = 0
    var isFinished = false
    
    var equalNumber = 3
    
    private var indexPathsToClose = [IndexPath]()
    
    var needToClose = false
    
    private func closeCellsIfNeed() {
        
        guard needToClose else {
            return
        }
        
        needToClose = false
        
        indexPathsToClose.forEach {
            assert(gameModels[$0.item].isAlwayesOpened == true)
            gameModels[$0.item].isAlwayesOpened = false
        }
        
        delegate?.closeCells(at: indexPathsToClose)
        openedCount -= indexPathsToClose.count
        indexPathsToClose.removeAll()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        if isFinished {
            return
        }
        
        let selectedModel = gameModels[indexPath.row]
        
        if selectedModel.isAlwayesOpened {
            return
        }
        
        selectedModel.isAlwayesOpened = true
        openedCount += 1
        delegate?.openCell(at: indexPath)
        
        if openedCount == gameModels.count {
            isFinished = true
            delegate?.gameDidFinished()
            return
        }
        
        closeCellsIfNeed()
        
        if let lastSelectedIndexPath = indexPathsToClose.last {
            let lastSelectedModel = gameModels[lastSelectedIndexPath.row]
            
            if selectedModel != lastSelectedModel {
                needToClose = true
                indexPathsToClose.append(indexPath)
            } else if indexPathsToClose.count == equalNumber - 1 {
//                assert(indexPathsToClose.count == equaleNumber - 1)
                indexPathsToClose.removeAll()
            } else {
                indexPathsToClose.append(indexPath)
            }
        } else {
            indexPathsToClose.append(indexPath)
        }
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
    
    func copy() -> GameModel {
        return GameModel(id: id, emojy: emojy)
    }
}

extension GameModel: Equatable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
        return lhs.id == rhs.id
    }
}
