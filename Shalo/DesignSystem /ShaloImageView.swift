import UIKit

final class ShaloImageView: UIImageView {
    init(systemName: String) {
        let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate)
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
