//
//  ViewController.swift
//  UniversalViewer
//
//  Created by Bondar Yaroslav on 2/1/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

import UIKit

extension UITabBar {
    func deselectCurrentItem() {
        /// check
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
        self.selectedItem = nil
        //        }
    }
}

final class CustomTabBarItem: UITabBarItem {
    
    override init() {
        super.init()
        setupTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTitle()
    }
    
    private func setupTitle() {
//        let font = UIFont.TurkcellSaturaMedFont(size: 11)
//        setTitleTextAttributes([.font: font], for: .normal)
    }
    
}

final class PhotoObject: NSObject, ViewObject {
    
    var topBarItems: [UIBarButtonItem]? = [UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil),
                                           UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)]
    
    var bottomBarItems: [UITabBarItem]? = []
//    var bottomBarItems: [UITabBarItem]? = [CustomTabBarItem(title: "qqweqwe", image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download")),
//                                           CustomTabBarItem(title: "qwe", image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download")),
//                                           CustomTabBarItem(title: "qwe", image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download"))]
    
    
    lazy var imageScrollView: ImageScrollView = {
        let imageScrollView = ImageScrollView()
//        imageScrollView.image = #imageLiteral(resourceName: "screen")
        imageScrollView.delegate = self
        return imageScrollView
    }()
    
    var view: UIView {
        return imageScrollView
    }
    
    func relayout() {
        imageScrollView.updateZoom()
    }
}
extension PhotoObject: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageScrollView.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageScrollView.adjustFrameToCenter()
    }
}


protocol ViewObject {
    var view: UIView { get }
    var topBarItems: [UIBarButtonItem]? { get }
    var bottomBarItems: [UITabBarItem]? { get }
    func relayout() 
}

//UniversalViewer
final class UniversalViewerController: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewObjects = [ViewObject]()
    
    //var hideActions = false
    /// удаление из массива
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        automaticallyAdjustsScrollViewInsets = false
//        edgesForExtendedLayout = .top
        
        tabBar.delegate = self
        tabBar.tintColor = .red
        
        collectionView.register(nibCell: ViewerCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewObjects.append(PhotoObject())
        
        let q = PhotoObject()
        q.bottomBarItems = []
//        q.bottomBarItems = [CustomTabBarItem(title: "1q1q1q1q1", image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download")),
//                            CustomTabBarItem(title: "opop pp", image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download"))]
        q.topBarItems = [UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)]
        viewObjects.append(q)
        
        viewObjects.append(PhotoObject())
        viewObjects.append(PhotoObject())
        viewObjects.append(PhotoObject())
        viewObjects.append(PhotoObject())
        
        collectionView.reloadData()
        
        let viewObject = viewObjects[0]
        navigationItem.rightBarButtonItems = viewObject.topBarItems
        tabBar.items = viewObject.bottomBarItems
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = collectionView.bounds.size
//            collectionView.setCollectionViewLayout(layout, animated: true)
//        }
        
        
//        collectionView.collectionViewLayout.invalidateLayout()
        
//        collectionView.reloadData()
        
        collectionView.performBatchUpdates(nil, completion: nil)
        
        if let indexPath = indexPath {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self.indexPath = nil
//            collectionView.performBatchUpdates({}, completion: nil)
        } 
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
//        return navigationController?.isNavigationBarHidden == true
        return tabBar?.transform == .identity
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func hideBarsAnimated(hide: Bool) {
        UIApplication.shared.isStatusBarHidden = hide
        navigationController?.setNavigationBarHidden(hide, animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
//                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -70)
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
            } else {
//                self.navigationController?.navigationBar.transform = .identity
                self.tabBar.transform = .identity
            }
        })
    }
    
    var indexPath: IndexPath?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
//        collectionViewSizeChanged = true
        
        var offestPoint = self.collectionView.contentOffset
        offestPoint.x += self.collectionView.center.x
        indexPath = self.collectionView.indexPathForItem(at: offestPoint)
        
//        
//
//        
//        coordinator.animate(alongsideTransition: nil) { _ in
//            
////            self.collectionView.performBatchUpdates({ 
////                self.collectionView.setCollectionViewLayout(self.collectionView.collectionViewLayout, animated: true)
////                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
////            }, completion: nil)
//            
//            self.collectionView.collectionViewLayout.invalidateLayout()
////
////            
//            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
////            
////            
////            self.collectionView.collectionViewLayout.invalidateLayout()
//        }
    }
    
}

extension UniversalViewerController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.deselectCurrentItem()
    }
}

extension UniversalViewerController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = collectionView.contentOffset.x
        let w = collectionView.bounds.size.width
        var currentPage = Int(ceil(x/w))
        
        if currentPage >= viewObjects.count {
            currentPage = viewObjects.count - 1
        }
        print(currentPage)
        
        let viewObject = viewObjects[currentPage]
        navigationItem.rightBarButtonItems = viewObject.topBarItems
        tabBar.items = viewObject.bottomBarItems
    }
}

extension UniversalViewerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewObjects.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: ViewerCell.self, for: indexPath)
        cell.tapHandler = {
//            self.hideBarsAnimated(hide: !self.navigationController!.navigationBar.isHidden)
            self.hideBarsAnimated(hide: self.tabBar.transform == .identity)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ViewerCell else { return }
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
        cell.fill(with: viewObjects[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = cell as! PhotoCell
//        cell.imageView.kf.cancelDownloadTask()
    }
}
extension UniversalViewerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
//        let image = cell.imageView.image ?? UIImage()
//        let browser = SKPhotoBrowser(originImage: image, photos: createWebPhotos(), animatedFromView: cell)
//        browser.initializePageIndex(indexPath.row)
//        browser.delegate = self
//        present(browser, animated: true, completion: nil)
    }
    
}
extension UniversalViewerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
