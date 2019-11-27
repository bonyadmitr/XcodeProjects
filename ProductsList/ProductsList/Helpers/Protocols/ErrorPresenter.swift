import UIKit
import Alamofire

protocol ErrorPresenter {
    func showErrorAlert(with message: String)
    func showErrorAlert(for error: Error)
}
extension ErrorPresenter where Self: UIViewController {
    
    func showErrorAlert(with message: String) {
        /// not .actionSheet bcz of https://stackoverflow.com/q/55372093/5893286
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        //let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //vc.addAction(okAction)
        /// short way
        vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
        
        vc.popoverPresentationController?.sourceView = view
        //vc.popoverPresentationController?.sourceRect = view.frame
        vc.popoverPresentationController?.permittedArrowDirections = []
        
        /// there is bug with refreshControl.endRefreshing() and UIAlertController
        /// more info https://stackoverflow.com/q/41534375/5893286
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    private func defalutHandler(error: Error) {
        showErrorAlert(with: error.localizedDescription)
    }
    
    func showErrorAlert(for error: Error) {
        print(error.debugDescription)
        
        do {
            try handleAlamofireError(error)
        } catch {
            defalutHandler(error: error)
        }
    }
    
    private func handleAlamofireError(_ error: Error) throws {
        guard let afError = error as? AFError else {
            throw error
        }
        
        switch afError {
        case .sessionTaskFailed(error: let sessionError):
            
            /// internet error
            if let urlError = sessionError as? URLError {
                showErrorAlert(with: urlError.localizedDescription)
            } else {
                defalutHandler(error: sessionError)
            }
            
        default:
            defalutHandler(error: afError)
        }
    }
    
}

extension UIViewController {
    
    func presentIPadSafe(controller: UIViewController) {
        controller.popoverPresentationController?.sourceView = view
        //controller.popoverPresentationController?.sourceRect = view.frame
        controller.popoverPresentationController?.permittedArrowDirections = []
        present(controller, animated: true, completion: nil)
    }
}
