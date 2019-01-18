import UIKit

final class PhotosController: UIViewController {
    
    enum SelectionState {
        case selecting
        case ended
    }
    
    var selectionState = SelectionState.selecting
    
    private let cellId = String(describing: PhotoCell.self)
    
    internal lazy var collectionView: UICollectionView = {
        let isIpad = UI_USER_INTERFACE_IDIOM() == .pad
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = isIpad ? 10 : 1
        layout.minimumInteritemSpacing = isIpad ? 10 : 1
        layout.sectionInset = .init(top: 1, left: 1, bottom: 1, right: 1)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        
        return collectionView
    }()
    
    private var photos = [WebPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        title = "Photos"
        readJson()
        
        collectionView.reloadData()
    }
    
    private func readJson() {
        guard
            let file = Bundle.main.url(forResource: "photos", withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let photos = try? JSONDecoder().decode([WebPhoto].self, from: data)
            else {
                assertionFailure()
                return
        }
        self.photos = photos
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCell else {
            assertionFailure()
            return
        }
        let item = photos[indexPath.row]
//
        cell.update(for: selectionState)
//        switch selectionState {
//        case .selecting:
//            cell.sizeLabel.text = "selecting"
//        case .ended:
//            if cell.isSelected {
//                cell.sizeLabel.text = "ready"
//            } else {
//                cell.sizeLabel.text = ""
//            }
//        }
        
        URLSession.shared.dataTask(with: item.thumbnailUrl) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                cell.imageView.image = image
            }
            }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? PhotoCell else {
//            assertionFailure()
//            return
//        }
        //photoLoadingManager.end(cell: cell, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        
        if selectedCount == 5 {
            
            selectionState = .ended
            
            let cells = collectionView.indexPathsForVisibleItems.compactMap({ collectionView.cellForItem(at: $0) as? PhotoCell })
            cells.forEach({ $0.update(for: selectionState) })
        } else {
            selectionState = .selecting
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
                assertionFailure()
                return
            }
            
            cell.update(for: selectionState)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        selection()
        
        let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        
        selectionState = .selecting
        
        if selectedCount == 5 - 1 {
            let cells = collectionView.indexPathsForVisibleItems.compactMap({ collectionView.cellForItem(at: $0) as? PhotoCell })
            cells.forEach({ $0.update(for: selectionState) })
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
                assertionFailure()
                return
            }
            
            cell.update(for: selectionState)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch selectionState {
        case .selecting:
            return true
        case .ended:
            return false
        }
//        let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
//        return selectedCount < 5
//        if selectedCount == 5 {
//            return false
//        }
    }
    
    private func selection() {
        
        //        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
        //            assertionFailure()
        //            return
        //        }
        
        guard let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else {
            assertionFailure()
            return
        }
        
        
        
        let cells = collectionView.indexPathsForVisibleItems.compactMap({ collectionView.cellForItem(at: $0) as? PhotoCell })
        
        let selectedCount = indexPathsForSelectedItems.count
        if selectedCount == 5 {
            selectionState = .ended
            
            
            //            collectionView.visibleCells
            //                .compactMap({ $0 as? PhotoCell })
//            cells.forEach({ cell in
//                if cell.isSelected {
//                    cell.sizeLabel.text = "ready"
//                } else {
//                    cell.sizeLabel.text = ""
//                }
//            })
        } else {
            selectionState = .selecting
            //            collectionView.visibleCells
            //                .compactMap({ $0 as? PhotoCell })
            //                .forEach({ $0.sizeLabel.text = "" })
            
//            cells.forEach({ cell in
//                if cell.isSelected {
//                    cell.sizeLabel.text = "ready"
//                } else {
//                    cell.sizeLabel.text = "selecting"
//                }
//            })
        }
        cells.forEach({ $0.update(for: selectionState) })
        //        collectionView.performBatchUpdates({
        //            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        //        }, completion: nil)
    }
}

extension PhotosController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4 - 3
        return CGSize(width: width, height: width)
    }
}

extension PhotosController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //updateCachedAssetsFor
    }
}

final class PhotoCell2: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isOpaque = true
        return imageView
    }()
    
    var representedIdentifier = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        layer.borderColor = UIColor.red.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 3
            } else {
                layer.borderWidth = 0
            }
        }
    }
}


final class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isOpaque = true
        return imageView
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textColor = .white
        return label
    }()
    
    var representedAssetIdentifier = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(sizeLabel)
        assert(subviews.firstIndex(of: sizeLabel) ?? 0 > subviews.firstIndex(of: imageView) ?? 0)
        layer.borderColor = UIColor.red.cgColor
    }
    
    let sizeLabelHeight: CGFloat = 20
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        sizeLabel.frame = CGRect(x: 0, y: bounds.height - sizeLabelHeight, width: bounds.width, height: sizeLabelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        sizeLabel.text = ""
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
//                sizeLabel.text = "Selected"
                layer.borderWidth = 3
            } else {
//                sizeLabel.text = ""
                layer.borderWidth = 0
            }
        }
    }
    
    func update(for selectionState: PhotosController.SelectionState) {
        
        if self.isSelected {
            self.sizeLabel.text = "ready"
        } else {
            switch selectionState {
            case .selecting:
                self.sizeLabel.text = "selecting"
            case .ended:
                self.sizeLabel.text = ""
            }
        }
        
    }
}

struct WebPhoto: Decodable {
    let thumbnailUrl: URL
    let url: URL
}
extension WebPhoto: Equatable {
    static func == (lhs: WebPhoto, rhs: WebPhoto) -> Bool {
        return lhs.thumbnailUrl == rhs.thumbnailUrl && lhs.url == rhs.url
    }
}
extension WebPhoto: Hashable {
    var hashValue: Int {
        return thumbnailUrl.hashValue// + url.hashValue
    }
}
