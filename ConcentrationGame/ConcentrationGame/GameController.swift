import UIKit

final class GameController: UIViewController {

    private let game = Game()
    
    private let gameCellId = "GameCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let newValue = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        newValue.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        newValue.register(GameCell.self, forCellWithReuseIdentifier: gameCellId)
        newValue.dataSource = self
        newValue.delegate = self
        newValue.backgroundColor = UIColor.lightGray
        
        updateLayout(for: newValue)
        return newValue
    }()
    
    private func updateLayout(for collectionView: UICollectionView) {
        let viewWidth = UIScreen.main.bounds.width
        
        let columns: CGFloat = CGFloat(numberOfCollumns)
        let padding: CGFloat = 1
        let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
        }
    }
    
    var numberOfRaws = 4
    var numberOfCollumns = 4
    var equalNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        game.delegate = self
        game.start(raws: numberOfRaws, collumns: numberOfCollumns, equalNumber: equalNumber)
        // TODO: update lauout
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout(for: collectionView)
//            collectionView.collectionViewLayout.invalidateLayout()
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
        
        let vc = UIAlertController(title: "Finished", message: nil, preferredStyle: .alert)
        vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    func closeCells(at indexPathes: [IndexPath]) {
        indexPathes.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
                /// cell is not visible or GameCell
                return
            }
            cell.close()
        }
    }
    
    func openCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else {
            /// cell is not visible or GameCell
            return
        }
        cell.open()
    }
}
