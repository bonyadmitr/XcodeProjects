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

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
  
  var interactionInProgress = false
  
  fileprivate var shouldCompleteTransition = false
  fileprivate weak var viewController: UIViewController!
  
  func wireToViewController(_ viewController: UIViewController!) {
    self.viewController = viewController
    prepareGestureRecognizerInView(viewController.view)
  }
  
  fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
    gesture.edges = UIRectEdge.left
    view.addGestureRecognizer(gesture)
  }
  
  func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    
    let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
    var progress = (translation.x / 200)
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
    
    switch gestureRecognizer.state {
      
    case .began:
      interactionInProgress = true
      viewController.dismiss(animated: true, completion: nil)
      
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
      
    case .cancelled:
      interactionInProgress = false
      cancel()
      
    case .ended:
      interactionInProgress = false
      
      if !shouldCompleteTransition {
        cancel()
      } else {
        finish()
      }
      
    default:
      print("Unsupported")
    }
  }
}
