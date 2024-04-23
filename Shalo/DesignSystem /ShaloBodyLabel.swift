import UIKit

final class ShaloBodyLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 10, weight: .medium)
        self.numberOfLines = 0
        self.textColor = .lightGray
        self.textAlignment = .left
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
