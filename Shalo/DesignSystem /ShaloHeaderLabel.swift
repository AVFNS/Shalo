import UIKit

final class ShaloHeaderLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 13, weight: .medium)
        self.numberOfLines = 1
        self.textColor = .darkGray
        self.textAlignment = .left
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
