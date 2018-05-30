//
//  UIViewExtension.swift
//  Feed Me
//
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

extension UIView {
  
  func lock() {
    if let _ = viewWithTag(10) {
      //View is already locked
    }
    else {
      let lockView = UIView(frame: bounds)
      lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
      lockView.tag = 10
      lockView.alpha = 0.0
      let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
      activity.hidesWhenStopped = true
      activity.center = lockView.center
      lockView.addSubview(activity)
      activity.startAnimating()
      addSubview(lockView)
      
      UIView.animateWithDuration(0.2) {
        lockView.alpha = 1.0
      }
    }
  }
  
  func unlock() {
    if let lockView = viewWithTag(10) {
      UIView.animateWithDuration(0.2, animations: {
        lockView.alpha = 0.0
        }) { finished in
          lockView.removeFromSuperview()
      }
    }
  }
  
  func fadeOut(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 1.0
    }
  }
  
  class func viewFromNibName(name: String) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
    return views.first as? UIView
  }
}
