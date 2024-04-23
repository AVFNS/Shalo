import UIKit
import AVFoundation
import Photos
import Then
import SnapKit

final class TrimViewController: UIViewController {
    let toolBar = UIToolbar(
        frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
    ).then {
        $0.tintColor = .darkGray
    }
    
    let asset: AVURLAsset
    let maxVideoDuration: Double
    let videoViewController: VideoViewController
    let sliderView: TopSliderView
    
    let completion: (URL?) -> Void
    
    let doneItem = UIBarButtonItem(
        image: UIImage(systemName: "checkmark"),
        style: .plain,
        target: self,
        action: #selector(applyTrim)
    )
    
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?
        .withRenderingMode(.alwaysTemplate))
    
    var previousTranslation: CGPoint = .zero
    var isVerticalPan = false

    var currentVideoDuration: Double {
        didSet {
            doneItem.isEnabled = currentVideoDuration != maxVideoDuration
        }
    }
    
    lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture)
    )
    
    init(url: URL, didFinishWithVideoURL completion: @escaping (URL?) -> Void) {
        self.completion = completion
        asset = AVURLAsset(url: url)
        videoViewController = VideoViewController(asset: asset)
        maxVideoDuration = asset.duration.seconds
        sliderView = TopSliderView(
            name: "Cut".localized(),
            value: maxVideoDuration,
            minPercent: 0.0
        )
        currentVideoDuration = maxVideoDuration
        super.init(nibName: nil, bundle: nil)
        sliderView.didChangeValue = { [weak self] value in
            self?.updateCurrentDuration(value)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        setUpToolBar()
        setUpPanGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func setUpToolBar() {
        func spacer() -> UIBarButtonItem {
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        let cancelItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(cancelAdjustment))
        
        let items = [cancelItem, spacer(), doneItem]
        toolBar.setItems(items, animated: false)
    }

    private func setUpPanGestureRecognizer() {
        videoViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        self.view.addSubviews([
            videoViewController.view,
            sliderView,
            toolBar])
        
        sliderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        toolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(44)
        }
        
        videoViewController.view.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(toolBar.snp.top)
        }
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: videoViewController.view)
        
        if recognizer.state == .began {
            let velocity = recognizer.velocity(in: self.view)
            isVerticalPan = abs(velocity.y) > abs(velocity.x) ? true : false
        }
        if isVerticalPan {

        } else {
            updateSlider(translation: translation, state: recognizer.state)
        }
    }
    
    private func updateCurrentDuration(_ value: Double) {
        currentVideoDuration = value
    }
    
    private func updateSlider(translation: CGPoint, state: UIGestureRecognizer.State) {
        let deltaX = previousTranslation.x - translation.x
        previousTranslation.x = translation.x
        sliderView.setDelta(deltaX)
        switch state {
        case .ended:
            previousTranslation = .zero
        default: break
        }
    }
    
    @objc private func cancelAdjustment() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyTrim() {
        videoViewController.isActivityIndicatorVisible = true
        guard let asset = videoViewController.player.currentItem?.asset,
              let session = VideoEditor.trimSession(asset: asset, startTime: 0.0, endTime: 2.0) else {
            dismiss(animated: true) {
                self.completion(nil)
            }
            return
        }
        
        session.export { result in
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    switch result {
                    case let .success(url):
                        self.completion(url)
                    case .failure:
                        self.completion(nil)
                    }
                }
            }
        }
    }
}
