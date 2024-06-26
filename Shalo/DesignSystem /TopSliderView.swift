import UIKit
import Then
import SnapKit

final class TopSliderView: UIView {
    typealias DidChangeValueCallback = (Double) -> Void
    let separatorLayer = CAShapeLayer()
    
    var k: CGFloat {
        let divider: CGFloat = minPercent == 0 ? 1 : 2
        return bounds.width / divider / 100.0
    }
    
    var name: String { didSet { setNeedsLayout() } }
    var percent: Double {
        didSet {
            didChangeValue?(percent)
            setNeedsLayout()
        }
    }
    var isPositive: Bool { percent >= 0 }
    
    var maxPercent: Double = 100.0
    var minPercent: Double {
        didSet {
            setNeedsLayout()
        }
    }
    
    var centerX: CGFloat {
        minPercent == 0 ? 0 : bounds.width/2.0
    }
    
    private let sliderLayer = CAShapeLayer()
    private let valueLabel = UILabel()
    private var progress: CGFloat { CGFloat(percent) * k }
    var didChangeValue: DidChangeValueCallback?
    
    init(name: String, value: Double, minPercent: Double) {
        self.name = name
        self.percent = value
        self.minPercent = minPercent
        super.init(frame: .zero)
        backgroundColor = .clear
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSeparatorSliderPosition()
        updateValueSlider()
        updateValueLabel()
    }
    
    private func setUpViews() {
        let sliderView = makeSliderView()
        let parameterValueView = ParameterValueView(label: valueLabel)
        let labelStackView = UIStackView(arrangedSubviews: [parameterValueView]).then {
            $0.axis = .vertical
            $0.alignment = .center
        }
        
        let stackView = UIStackView(arrangedSubviews: [sliderView, labelStackView]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        addSubview(stackView)
        
        sliderView.snp.makeConstraints {
            $0.height.equalTo(6)
        }

        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setDelta(_ deltaX: CGFloat) {
        setProgress(percent - Double(deltaX/k))
    }
    
    private func setProgress(_ percent: Double) {
        if percent > maxPercent {
            self.percent = maxPercent
        } else if percent < minPercent {
            self.percent = minPercent
        } else {
            self.percent = percent
        }
    }
    
    private func updateValueSlider() {
        let path = UIBezierPath(
            rect: CGRect(
                origin: .zero,
                size: CGSize(
                    width: isPositive ? progress : -progress,
                    height: 6
                )
            )
        ).cgPath
        
        let position = CGPoint(
            x: isPositive ? centerX : centerX - -progress,
            y: 0
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        sliderLayer.path = path
        sliderLayer.position = position
        CATransaction.commit()
    }
    
    private func updateValueLabel() {
        valueLabel.text = name + " " + "\(isPositive ? "+" : "")" + "\(Int(percent))"
    }
    
    private func makeSliderView() -> UIView {
        let sliderView = UIView()
        sliderView.backgroundColor = .white
        
        sliderLayer.lineWidth = 0.0
        sliderLayer.strokeColor = UIColor.clear.cgColor
        sliderLayer.fillColor = UIColor.systemBlue.cgColor
        sliderView.layer.addSublayer(sliderLayer)
        
        separatorLayer.lineWidth = 0.0
        separatorLayer.strokeColor = UIColor.clear.cgColor
        separatorLayer.fillColor = UIColor.darkGray.cgColor
        sliderView.layer.addSublayer(separatorLayer)
        
        return sliderView
    }
    
    private func setSeparatorSliderPosition() {
        let path = UIBezierPath(
            rect: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 1,
                    height: 12
                )
            )
        ).cgPath
        let position = CGPoint(
            x: centerX,
            y: 0
        )
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        separatorLayer.path = path
        separatorLayer.position = position
        CATransaction.commit()
    }
}
