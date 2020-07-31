import UIKit

/// xib error: soltuion: set `default` background color
/// Setting the background color on UITableViewHeaderFooterView has been deprecated. Please set a custom UIView with your desired background color to the backgroundView property instead
final class TitleHeaderView: UITableViewHeaderFooterView {
    
    private let backColor = UIColor.systemBlue
    
    @IBOutlet private weak var titleLabel: UILabel! {
        willSet {
            newValue.textColor = UIColor.white
            newValue.backgroundColor = backColor
            newValue.isOpaque = true
        }
    }
    
    @IBOutlet private weak var arrowImageView: UIImageView! {
        willSet {
            newValue.contentMode = .center
        }
    }
    
    private var section = 0
    private var tapHandler: (Int) -> Void = {_ in}
    
    func setup(title: String, section: Int, tapHandler: @escaping (Int) -> Void) {
        titleLabel.text = title
        self.section = section
        self.tapHandler = tapHandler
    }
    
    var isExpanded: Bool { arrowImageView.isUpRotated }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isOpaque = true
        contentView.isOpaque = true
        contentView.backgroundColor = backColor
        
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapGesture() {
        tapHandler(section)
        arrowImageView.rotateUpDown()
    }
    
}

private extension UIView {
    func rotateUpDown(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = self.isUpRotated ? CGAffineTransform(rotationAngle: .pi) : .identity
        })
    }
    
    var isUpRotated: Bool {
        return transform == .identity
    }
}
