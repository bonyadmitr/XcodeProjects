import UIKit

final class PhotoService {
    
    private var photos: [WebPhoto]?
    
    func loadPhotos(page: Int, size: Int, handler: @escaping ([WebPhoto]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            
            if page == 3 {
                DispatchQueue.main.async {
                    handler([])
                }
                return
            }
            
            guard let photos = self.getPhotos() else {
                DispatchQueue.main.async {
                    handler([])
                }
                return
            }
            
            let result: [WebPhoto]
            let offset = page * size
            let photosLeft = photos.count - offset
            
            if photosLeft <= 0 {
                result = []
            } else {
                
                if photosLeft < size {
                    result = Array(photos[offset ..< offset + photosLeft])
                    self.photos = nil
                } else {
                    let pageLimit = (page + 1) * size
                    result = Array(photos[offset ..< pageLimit])
                }
            }
            
            DispatchQueue.main.async {
                handler(result)
            }
        }
    }
    
    private func getPhotos() -> [WebPhoto]? {
        if let photos = photos {
            return photos
        } else {
            guard
                let file = Bundle.main.url(forResource: "photos", withExtension: "json"),
                let data = try? Data(contentsOf: file),
                let photos = try? JSONDecoder().decode([WebPhoto].self, from: data)
                else {
                    assertionFailure()
                    return nil
            }
            self.photos = photos
            return photos
        }

    }
}

final class PhotosController: UIViewController {
    
    enum SelectionState {
        case selecting
        case ended
    }
    
    private let photoService = PhotoService()
    private let paginationSize = 32
    private var paginationPage = 0
    private var isLoadingMore = false
    private var isLoadingMoreFinished = false
    
    private let selectingLimit = 5
    private var selectionState = SelectionState.selecting
    
    private var photos = [WebPhoto]()
    private let cellId = String(describing: PhotoCell.self)
    private let footerId = String(describing: CollectionViewSpinnerFooter.self)
    
    private lazy var collectionView: UICollectionView = {
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
        collectionView.register(CollectionViewSpinnerFooter.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                withReuseIdentifier: footerId)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        
        let transparentGradientViewHeight: CGFloat = 100
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: transparentGradientViewHeight, right: 0)
        
        return collectionView
    }()
    
    
    private lazy var loadingMoreFooterView: CollectionViewSpinnerFooter? = {
        return collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: IndexPath(item: 0, section: 0)) as? CollectionViewSpinnerFooter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        title = "Photos"
        
        //readJson()
        loadMore()
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
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
    
    private func loadMore() {
        if isLoadingMore, isLoadingMoreFinished {
            assertionFailure()
            return
        }
        
        isLoadingMore = true

        self.photoService.loadPhotos(page: paginationPage, size: paginationSize, handler: { photos in
            let newItemsRange = self.photos.count ..< (self.photos.count + photos.count)
            let indexPathesForNewItems = newItemsRange.map({ IndexPath(item: $0, section: 0) })
            self.photos.append(contentsOf: photos)
            
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: indexPathesForNewItems)
            }, completion: { _ in
                self.isLoadingMore = false
                self.paginationPage += 1
                let isLoadingMoreFinished = photos.count < self.paginationSize
                
                if isLoadingMoreFinished {
                    self.isLoadingMoreFinished = true
                    
                    /// to hide footer view by func referenceSizeForFooterInSection
                    self.collectionView.performBatchUpdates({
                        self.collectionView.collectionViewLayout.invalidateLayout()
                    }, completion: nil)
                    
                    /// just in case stop animation.
                    /// don't forget to start animation if need (for pullToRefresh)
                    self.loadingMoreFooterView?.stopSpinner()
                }
            })
        })
    }
    
    /// need cancel last request if pullToRequest before end
    private func reloadData() {
        self.loadingMoreFooterView?.startSpinner()
        self.photos.removeAll()
        collectionView.reloadData()
        isLoadingMoreFinished = false
        paginationPage = 0
        /// call after resetting paginationPage
        loadMore()
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
        cell.update(for: selectionState)
        
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
        
        /// load more
        if !isLoadingMoreFinished, !isLoadingMore, indexPath.row == photos.count - 1 {
            loadMore()
        }
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
        
        if selectedCount == selectingLimit {
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
        let selectedCount = collectionView.indexPathsForSelectedItems?.count ?? 0
        selectionState = .selecting
        
        if selectedCount == selectingLimit - 1 {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoadingMore {
            //return CGSize(width: collectionView.contentSize.width, height: 50)
            return CGSize(width: 0, height: 50)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //isLoadingMore
//        if kind == UICollectionElementKindSectionFooter,
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as? CollectionViewSpinnerFooter
//        {
//            footerView.startSpinner()
//            return footerView
//        } else {
//            assertionFailure("Unexpected element kind")
//            return UICollectionReusableView()
//        }
        
        if kind == UICollectionElementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath)
        } else {
            assertionFailure("Unexpected element kind")
            return UICollectionReusableView()
        }
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
    
    func update(for selectionState: PhotosController.SelectionState) {
        
        if self.isSelected {
            self.sizeLabel.text = "ready"
            layer.borderWidth = 3
        } else {
            layer.borderWidth = 0
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

final class CollectionViewSpinnerFooter: UICollectionReusableView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        //activity.color = UIColor.red
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = center
    }
    
    func startSpinner() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func stopSpinner() {
        activityIndicator.stopAnimating()
    }
}
