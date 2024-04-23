import UIKit

final class FiltersViewButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.3) : UIColor.clear
        }
    }
    
    init(imageName: String) {
        super.init(frame: .zero)
        self.imageView?.contentMode = .scaleAspectFit
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
