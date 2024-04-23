import UIKit

final class ShaloSaveCopyVideoButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.1) : UIColor.clear
        }
    }
}
