import Foundation

// TODO: currentEmojiCategory selection
// TODO: guard in isAvailableToStartWith for currentEmojiCategory
// TODO: game timer
// TODO: option open all cards for some seconds at the beginning

/// for novice
/// https://habr.com/ru/company/skillbox/blog/447598/
/// https://github.com/Xiomara7/Memory

protocol GameDelegate: class {
    func closeCells(at indexPathes: [IndexPath])
    func openCell(at indexPath: IndexPath)
    func gameDidFinished()
}

extension Game {
    static func isAvailableToStartWith(raws: Int, collumns: Int, equalNumber: Int) -> Bool {
        return (raws * collumns) % equalNumber == 0
    }
}

final class Game {
    
    weak var delegate: GameDelegate?
    
    var gameModels = [GameModel]()
    
    private(set) var raws: Int = 0
    private(set) var collumns: Int = 0
    
    
    private var openedCount = 0
    private var isFinished = false
    
    private var equalNumber = 3
    
    private var indexPathsToClose = [IndexPath]()
    
    private var needToClose = false
    
    private func currentEmojiCategory() -> [String]? {
        return Emoji.shared.emojiCategories["people"]
    }
    
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
        
        guard let emojiCategory = currentEmojiCategory() else {
            assertionFailure()
            return
        }
        
        assert(emojiCategory.count >= totalCells)
        
        var emojies = [String]()
        while emojies.count < createCellsCount {
            guard let randomEmojy = emojiCategory.randomElement() else {
                assertionFailure()
                return
            }
            if !emojies.contains(randomEmojy) {
                emojies.append(randomEmojy)
            }
        }
        
        assert(emojies.count == createCellsCount)
        
        /// create gameModels
        let gameModelsToCopy = emojies.enumerated().map { GameModel(id: $0.offset, emojy: $0.element) }
        gameModels = gameModelsToCopy
        
        /// copy gameModels
        for _ in 2...equalNumber {
            gameModels += gameModelsToCopy.map { $0.copy() }
        }
        
        gameModels.shuffle()
        
        assert(gameModels.count == totalCells)
    }

    /// close wrong selected cards
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
        
        assert(!indexPathsToClose.isEmpty)
        /// call at the end
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
        
        /// check second+ selected model
        if let lastSelectedIndexPath = indexPathsToClose.last {
            
            let lastSelectedModel = gameModels[lastSelectedIndexPath.row]
            
            /// wrong card selected
            if selectedModel != lastSelectedModel {
                needToClose = true
                indexPathsToClose.append(indexPath)
                
            /// we found all equal models
            } else if indexPathsToClose.count == equalNumber - 1 {
                indexPathsToClose.removeAll()
                
            /// we found next equal model (for 'equalNumber' >= 3)
            } else {
                indexPathsToClose.append(indexPath)
            }
            
        /// first model selected
        } else {
            indexPathsToClose.append(indexPath)
        }
    }
}
