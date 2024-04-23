import UIKit
import Then
import SnapKit

final class ParameterValueView: UIView {
    
    var valueLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .darkGray
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    let labelContainer = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 12.0
        $0.layer.masksToBounds = true
    }
    
    init(label: UILabel) {
        self.valueLabel = label
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        addSubview(labelContainer)
        labelContainer.addSubview(valueLabel)

        labelContainer.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        valueLabel.snp.makeConstraints {
            $0.leading.equalTo(labelContainer.snp.leading).offset(12)
            $0.trailing.equalTo(labelContainer.snp.trailing).offset(-12)
            $0.top.equalTo(labelContainer.snp.top).offset(6)
            $0.bottom.equalTo(labelContainer.snp.bottom).offset(-6)
        }
    }
}

