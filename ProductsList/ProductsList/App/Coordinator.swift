import UIKit

/// aritcle https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
/// Advanced Coordinators in iOS https://www.youtube.com/watch?v=ueByb0MBMQ4
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

// MARK: - MainCoordinator
final class MainCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        
        navigationController.delegate = self
    }

    func start() {
        let vc = ProductsListController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetail(item: ProductsListController.View.Item) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, item: item)
        detailCoordinator.start()
        childCoordinators.append(detailCoordinator)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        guard let childIndex = childCoordinators.enumerated().first(where: { $0.element === child })?.offset else {
            assertionFailure("- \(child.debugDescription) not found in \(childCoordinators)")
            return
        }
        childCoordinators.remove(at: childIndex)
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let detailVC = fromVC as? ProductDetailController {
            childDidFinish(detailVC.coordinator)
        }
    }
}

// MARK: - DetailCoordinator
final class DetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let item: ProductsListController.View.Item
    
    init(navigationController: UINavigationController, item: ProductsListController.View.Item) {
        self.item = item
        self.navigationController = navigationController
    }
    
    func start() {
        let detailVC = ProductDetailController(item: item)
        detailVC.coordinator = self
        
        #if os(tvOS)
        navigationController.present(detailVC, animated: true, completion: nil)
        #else
        navigationController.pushViewController(detailVC, animated: true)
        #endif
    }
}

