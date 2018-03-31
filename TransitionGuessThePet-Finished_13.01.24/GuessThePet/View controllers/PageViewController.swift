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

class PageViewController: UIPageViewController {
  
  let petCards = PetCardStore.defaultPets()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
  }
}

// MARK: Page view controller data source

extension PageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex {
        if pageIndex > 0 {
            return viewControllerAtIndex(pageIndex - 1)
        }
    }
    
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex {
        if pageIndex < petCards.count - 1 {
            return viewControllerAtIndex(pageIndex + 1)
        }
    }
    
    return nil
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return petCards.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }
}

// MARK: View controller provider

extension PageViewController: ViewControllerProvider {
  
  var initialViewController: UIViewController {
    return viewControllerAtIndex(0)!
  }
  
  func viewControllerAtIndex(_ index: Int) -> UIViewController? {
    
    if let cardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
      
      cardViewController.pageIndex = index
      cardViewController.petCard = petCards[index]
      
      return cardViewController
    }
    
    return nil
  }
}
