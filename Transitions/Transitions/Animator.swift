//
//  Animator.swift
//  Transitions
//
//  Created by Bondar Yaroslav on 24/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
