import UIKit

final class GameController: UIViewController {

    private let game = Game()
    
    private let gameCellId = "GameCell"
    
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
            
            newValue.register(GameCell.self, forCellWithReuseIdentifier: gameCellId)
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

    private var lastSelectedIndexPath: IndexPath?
    
    private var indexPathesToClose = [IndexPath]()
    
    /// close wrong cards
    private func closeCellsIfNeed() {
        if !indexPathesToClose.isEmpty {
            indexPathesToClose.forEach { indexPath in
                guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
                    assertionFailure()
                    return
                }
                cell.close()
            }
            indexPathesToClose.removeAll()
        }
    }
}

extension GameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.raws * game.collumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: gameCellId, for: indexPath)
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
        
        closeCellsIfNeed()
        
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
                indexPathesToClose += [indexPath, lastSelectedIndexPath]
            }
            
            self.lastSelectedIndexPath = nil
        } else {
            self.lastSelectedIndexPath = indexPath
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
            assertionFailure()
            return
        }
        
        cell.open(with: game.gameModels[indexPath.row].emojy)
    }
}


//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        (collectionView.bounds.width - CGFloat(numberOfCollumns - 1) * 1) / CGFloat(numberOfCollumns)
//        return CGSize(width: 100, height: 100)
//    }
//}
