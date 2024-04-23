import UIKit
import SnapKit
import Then

final class ToolsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ToolsCollectionViewCell"

    let toolImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let toolName = UILabel().then {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.lineBreakMode = .byWordWrapping
    }
    let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubviews(toolImageView, toolName)
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.greaterThanOrEqualTo(contentView.snp.bottom)
        }

        toolImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(toolImageView.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
