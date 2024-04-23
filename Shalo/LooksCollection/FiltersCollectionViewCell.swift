import UIKit
import SnapKit
import Then

final class FiltersCollectionViewCell: UICollectionViewCell {
    let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 6
    }
    let previewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let filterName = UILabel().then {
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        $0.font = UIFont.systemFont(ofSize: 9)
        $0.numberOfLines = 1
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                filterName.textColor = .blue
            } else {
                filterName.textColor = .gray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(previewImageView, filterName)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.equalTo(contentView.snp.bottom)
        }

        previewImageView.snp.makeConstraints {
            $0.height.equalTo(previewImageView.snp.width)
        }
    }
}
