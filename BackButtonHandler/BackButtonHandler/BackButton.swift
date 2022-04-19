//
//  BackButton.swift
//  BackButtonHandler
//
//  Created by Bondar Yaroslav on 09/04/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit

typealias VoidHandler = () -> Void

/// loose the "swipe to go back". `navigationController?.interactivePopGestureRecognizer?.delegate = self` to fix it
/// not so good animation for button and nav bar title during pop
final class BackButtonItem: UIBarButtonItem {
    
    /// use `[weak self] in` for `action` to avoid memory leak
    convenience init(title: String? = nil, action: @escaping VoidHandler) {
        let button = BackButtonView(title: title, action: action)
        self.init(customView: button)
    }
    
//    convenience init(action: @escaping VoidHandler) {
//        let button = BackButton(action: action)
//        self.init(customView: button)
//    }
}





final class BackButton: UIButton {

    private var action: VoidHandler?

    /// text color is not gray during alert like arrow image (see example)
    var buttonColor: UIColor {
        get {
            return tintColor
        }
        set (color) {
            tintColor = color
            setTitleColor(color, for: .normal)
            setTitleColor(color.darker(by: 50), for: .highlighted) /// not like system back button
        }
    }

    convenience init(action: @escaping VoidHandler) {
        self.init(type: .custom)
        self.action = action
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        /// image can be resized to be like system arrow
//        let image = UIImage(named: "im_default_back_button") /// as template
//        let image = UIImage(named: "im_backButton") /// as template
//        let image = UIImage(named: "backIndicatorImage") /// as template
        let image = UIImage(named: "backArrow") /// as template


        let title = NSLocalizedString("Back", comment: "")

        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        buttonColor = UIColor.systemBlue

        imageView?.contentMode = .scaleAspectFit
        let adjustSize: CGFloat = 2
        imageEdgeInsets = UIEdgeInsets(top: -1 + adjustSize, left: -15 + adjustSize, bottom: 0 + adjustSize, right: 0 + adjustSize)
        titleEdgeInsets = UIEdgeInsets(top: -1, left: 1, bottom: 0, right: -1)

//        sizeToFit()

        addTarget(self, action: #selector(actionTouchUp), for: .touchUpInside)
    }

    @objc private func actionTouchUp() {
        action?()
    }
}





final class BackButtonView: UIView {
    
    private let arrowImageView = UIImageView()
    private let titleLabel = UILabel()
    private let touchButton = UIButton(type: .custom)
    
    private let highlightedColor = UIColor.systemBlue.withAlphaComponent(0.4)
    
    private var action: VoidHandler?
    
    convenience init(title: String?, action: @escaping VoidHandler) {
        self.init(frame: .zero)
        self.action = action
        titleLabel.text = title ?? NSLocalizedString("Back", comment: "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        titleLabel.text = NSLocalizedString("Back", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        titleLabel.text = NSLocalizedString("Back", comment: "")
    }
    
    private func setup() {
        arrowImageView.contentMode = .scaleAspectFit
        
        /// or 1
        let base64EncodedImageData = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAACQAAABCBAMAAADNg2nsAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAVUExURUdwTEaM/0SL/0WN/0WP/0SK/0SK/5mP1MwAAAAGdFJOUwBf50wpr+TiczwAAABuSURBVDjLY2AgCAwN0EWM0pLQxBjT0tJSUIXEgEKpGIrSkjAUoQqBFaFqBCtCMR6iKE0AQ1HiqCK6KXLDUMQQhqGIQQ1DETYhLBqxGI/FEVicOqpsoJSlEMjIWLI7tkIBS9GBrYDBUgxhK6xAAACa2ZDv/A+rZAAAAABJRU5ErkJggg==")!
        arrowImageView.image = UIImage(data: base64EncodedImageData)?.withRenderingMode(.alwaysTemplate)
        
        /// or 2 from asset
        //arrowImageView.image = UIImage(named: "backArrow") /// as template
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        touchButton.addTarget(self, action: #selector(highlightButton), for: .touchDown)
        touchButton.addTarget(self, action: #selector(dehighlightButton), for: .touchDragOutside)
        touchButton.addTarget(self, action: #selector(highlightButton), for: .touchDragInside)
        touchButton.addTarget(self, action: #selector(dehighlightButton), for: .touchUpOutside)
        touchButton.addTarget(self, action: #selector(dehighlightButton), for: .touchCancel)
        touchButton.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        
        setButtonHighlighted(false)
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(touchButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        touchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -6.5),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor, multiplier: 6.0/11.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 10), /// 10 good for Back title, but not for custom one, didn't find connection
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.3),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            touchButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            touchButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            touchButton.topAnchor.constraint(equalTo: topAnchor),
            touchButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setButtonHighlighted(_ isHightlited: Bool) {
        let color = isHightlited ? highlightedColor : UIColor.systemBlue
        titleLabel.textColor = color
        arrowImageView.tintColor = color
        
        /// need to sync animation of titleLabel and arrowImageView
        //UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve) {
        //    self.titleLabel.textColor = color
        //    self.arrowImageView.tintColor = color
        //}
    }
    
    @objc private func highlightButton() {
        setButtonHighlighted(true)
    }
    
    @objc private func dehighlightButton() {
        setButtonHighlighted(false)
    }
    
    @objc private func onButton() {
        setButtonHighlighted(false)
        action?()
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        //action = nil
    }
    
    deinit {
        print("- deinit BackButtonView")
    }
    
}
