import UIKit

final class GameCell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        label.isOpaque = true
        
        //        label.font = UIFont.systemFont(ofSize: 70) //5se
        //        label.font = UIFont.systemFont(ofSize: 90) //6+
        //        label.numberOfLines = 1
        //        label.lineBreakMode = .byWordWrapping
        //        label.adjustsFontSizeToFitWidth = true
        //        label.minimumScaleFactor = 0.1
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if label.frame != bounds {
            label.frame = bounds
            label.font = label.font.withSize(bounds.height * 0.8)
        }
    }
    
    func open(with text: String) {
        //let q: UIView.AnimationOptions = cell.isShown ? .transitionFlipFromRight : .transitionFlipFromLeft
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            self.label.text = text
        }, completion: nil)
    }
    
    func close() {
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromLeft, .showHideTransitionViews], animations: {
            self.label.text = ""
        }, completion: nil)
    }
}
