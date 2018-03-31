//
//  PasscodeInputView.swift
//  Passcode
//
//  Created by Bondar Yaroslav on 10/2/17.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

public typealias Passcode = String

public protocol PasscodeInputViewDelegate: class {
    func finish(with passcode: Passcode)
    func finishErrorAnimation()
}

//@IBDesignable
public class PasscodeInputView: UIControl, PasscodeInput {
    
    @IBInspectable public var passcodeLength: Int = 4 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var dotDiametr: CGFloat = 30 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var dotWidth: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var dotColor: UIColor = UIColor.blue {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var errorColor: UIColor = UIColor.red {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var finishDelay: Double = 0.2
    
    @IBInspectable public var isActive: Bool = false {
        didSet {
            if isActive {
                becomeFirstResponder()
            } else {
                resignFirstResponder()
            }
        }
    }
    
    private var passcode: Passcode = "" {
        didSet { setNeedsDisplay() }
    }
    
    public func clearPasscode() {
        passcode = ""
    }
    
    public weak var delegate: PasscodeInputViewDelegate?
    
    private var isAnimatingError = false
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        becomeFirstResponder()
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setup(for: frame)
    }
    
    public override func draw(_ rect: CGRect) {
        setup(for: rect)
    }
    
    private lazy var radius: CGFloat = {
        return dotDiametr / 2
    }()
    
    private func setup(for rect: CGRect) {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let freeSpace = (rect.width - dotDiametr * CGFloat(passcodeLength)) / CGFloat(passcodeLength - 1)
        
        for i in 0..<passcodeLength {
            
            let x = CGFloat(i) * freeSpace + CGFloat(i) * dotDiametr + radius
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: x, y: rect.height / 2),
                                          radius: radius, startAngle: 0,
                                          endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.lineWidth = dotWidth
            
            if isAnimatingError {
                shapeLayer.fillColor = errorColor.cgColor
                shapeLayer.strokeColor = errorColor.cgColor
            } else {
                let fillColor = i < passcode.count ? dotColor : UIColor.clear
                shapeLayer.fillColor = fillColor.cgColor
                shapeLayer.strokeColor = dotColor.cgColor
            }
            
            layer.addSublayer(shapeLayer)
        }
    }
    
    public func animateError() {
        let saveX = frame.origin.x
        frame.origin.x -= 40
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.isAnimatingError = true
                self.setNeedsDisplay()
                self.frame.origin.x = saveX
        }, completion: { _ in
            self.isAnimatingError = false
            self.delegate?.finishErrorAnimation()
        })
    }
    
    // MARK: - UITextInputTraits
    
    public var keyboardType: UIKeyboardType = .numberPad
}

// MARK: - UIKeyInput
extension PasscodeInputView: UIKeyInput {
    public var hasText: Bool {
        return !passcode.isEmpty
    }
    
    public func insertText(_ text: String) {
        if isPasscodeFull { /// guard for passcodeLength length
            return
        }
        passcode.append(text)
        
        if isPasscodeFull {
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.asyncAfter(deadline: .now() + finishDelay ) {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.delegate?.finish(with: self.passcode)
            }
        }
    }
    
    public func deleteBackward() {
        if passcode.isEmpty {
            return
        }
        passcode.removeLast()
    }
    
    private var isPasscodeFull: Bool {
        return passcode.count == passcodeLength
    }
}
