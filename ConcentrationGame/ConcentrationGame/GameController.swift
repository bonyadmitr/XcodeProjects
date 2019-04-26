import UIKit

enum ConcentrationState {
    case start
    case wrongPaire
    case selection
    case finished
}

/// for novice
/// https://habr.com/ru/company/skillbox/blog/447598/
/// https://github.com/Xiomara7/Memory

final class ConcentrationGame {
    
    var raws: Int = 0
    var collumns: Int = 0
    
    var gameModels = [GameModel]()
    
    func start(raws: Int, collumns: Int) {
        self.raws = raws
        self.collumns = collumns
        
        let totalCells = raws * collumns
        if totalCells % 2 == 1 {
            assertionFailure()
            return
        }
        let createCellsCount = totalCells / 2
        
        var emojies = [String]()
        while emojies.count < createCellsCount {
            let randomEmojy = Emoji.shared.emojiCategories["people"]!.randomElement()!
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
}

final class GameModel {
    let id: Int
    let emojy: String
    var isOpened = false
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

final class GameController: UIViewController {

    private let game = ConcentrationGame()
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            let viewWidth = UIScreen.main.bounds.width
            
            let columns: CGFloat = CGFloat(numberOfCollumns)
            let padding: CGFloat = 1
            let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
            let itemSize = CGSize(width: itemWidth, height: itemWidth)
            
            if let layout = newValue.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = itemSize
                layout.minimumInteritemSpacing = padding
                layout.minimumLineSpacing = padding
            }
            
            
            newValue.register(GameCell.self, forCellWithReuseIdentifier: "GameCell")
            newValue.dataSource = self
            newValue.delegate = self
            
            newValue.backgroundColor = UIColor.lightGray
        }
    }
    
    let numberOfRaws = 4
    let numberOfCollumns = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.start(raws: numberOfRaws, collumns: numberOfCollumns)
        // TODO: update lauout
        collectionView.reloadData()
    }

    var lastSelectedIndexPath: IndexPath?
    
    
    var closeIndexPath1: IndexPath?
    var closeIndexPath2: IndexPath?
}

extension GameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.raws * game.collumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        
//        cell.label.text = game.gameModels[indexPath.row].emojy
        return cell
    }
}

extension GameController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if game.isFinished {
            return
        }
        
        if lastSelectedIndexPath == indexPath {
            return
        }
        
        let selectedModel = game.gameModels[indexPath.row]
        if selectedModel.isAlwayesOpened {
            return
        }
        
        if let closeIndexPath1 = closeIndexPath1, let closeIndexPath2 = closeIndexPath2 {
            self.closeIndexPath1 = nil
            self.closeIndexPath2 = nil
            let cell1 = collectionView.cellForItem(at: closeIndexPath1) as! GameCell
            let cell2 = collectionView.cellForItem(at: closeIndexPath2) as! GameCell
            cell1.close()
            cell2.close()
        }
        
        if let lastSelectedIndexPath = lastSelectedIndexPath {
            let lastSelectedModel = game.gameModels[lastSelectedIndexPath.row]
            
            if selectedModel == lastSelectedModel {
                selectedModel.isAlwayesOpened = true
                lastSelectedModel.isAlwayesOpened = true
                game.openedCount += 2
                
                if game.openedCount == game.gameModels.count {
                    game.isFinished = true
                    print("- finished")
                }
                
            } else {
                closeIndexPath1 = indexPath
                closeIndexPath2 = lastSelectedIndexPath
            }
            
            self.lastSelectedIndexPath = nil
        } else {
            self.lastSelectedIndexPath = indexPath
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! GameCell
        UIView.transition(with: cell, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            cell.label.text = self.game.gameModels[indexPath.row].emojy
        }, completion: nil)
        
//        let q: UIView.AnimationOptions = cell.isShown ? .transitionFlipFromRight : .transitionFlipFromLeft
//        UIView.transition(with: cell, duration: 0.5, options: [q, .showHideTransitionViews], animations: {
//            if cell.isShown {
//                cell.label.text = self.game.gameModels[indexPath.row].emojy
//            } else {
//                cell.label.text = ""
//            }
//        }, completion: nil)
    }
}


//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        (collectionView.bounds.width - CGFloat(numberOfCollumns - 1) * 1) / CGFloat(numberOfCollumns)
//        return CGSize(width: 100, height: 100)
//    }
//}
