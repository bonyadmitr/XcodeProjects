/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
import UIKit

private let revealSequeId = "revealSegue"

class CardViewController: UIViewController {
  
  var pageIndex: Int?
  var petCard: PetCard?
  
  @IBOutlet fileprivate weak var cardView: UIView!
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  
  fileprivate let flipPresentAnimationController = FlipPresentAnimationController()
  fileprivate let flipDismissAnimationController = FlipDismissAnimationController()
  
  fileprivate let swipeInteractionController = SwipeInteractionController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = petCard?.description
    cardView.layer.cornerRadius = 25
    cardView.layer.masksToBounds = true
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    cardView.addGestureRecognizer(tapRecognizer)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == revealSequeId, let destinationViewController = segue.destination as? RevealViewController {
      destinationViewController.petCard = petCard
      destinationViewController.transitioningDelegate = self
      swipeInteractionController.wireToViewController(destinationViewController)
    }
  }
  
  func handleTap() {
    performSegue(withIdentifier: revealSequeId, sender: nil)
  }
}

extension CardViewController: UIViewControllerTransitioningDelegate {

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    flipPresentAnimationController.originFrame = cardView.frame
    return flipPresentAnimationController
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    flipDismissAnimationController.destinationFrame = cardView.frame
    return flipDismissAnimationController
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
  }
}
