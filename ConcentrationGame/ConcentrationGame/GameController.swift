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
    
    let numberOfRaws = 5
    let numberOfCollumns = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        game.start(raws: numberOfRaws, collumns: numberOfCollumns, equalNumber: 3)
        // TODO: update lauout
        collectionView.reloadData()
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
        game.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? GameCell else {
            assertionFailure()
            return
        }
        let model = game.gameModels[indexPath.item]
        cell.setup(for: model)
    }
}

extension GameController: GameDelegate {
    func gameDidFinished() {
        print("- finished")
        UIAlertView(title: "Finished", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func closeCells(at indexPathes: [IndexPath]) {
        indexPathes.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
                return
            }
            cell.close()
        }
    }
    
    func openCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
            return
        }
        cell.open()
    }
}
