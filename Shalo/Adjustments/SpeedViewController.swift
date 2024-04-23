import UIKit
import AVFoundation
import Photos
import SnapKit
import Then

final class SpeedViewController: UIViewController {
    let toolBar = UIToolbar(
        frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
    ).then {
        $0.tintColor = .darkGray
    }
    let asset: AVURLAsset
    let videoViewController: VideoViewController
    let completion: (Result<URL, AVAssetExportSession.Error>) -> Void
    
    lazy var resumeImageView = UIImageView(image: UIImage(named: "playCircle")?
        .withRenderingMode(.alwaysTemplate))
    lazy var slowDownItem = getBarButtonItem("backward.fill", action: #selector(slowDown))
    lazy var speedUpItem = getBarButtonItem("forward.fill", action: #selector(speedUp))
    lazy var doneItem = getBarButtonItem("checkmark", action: #selector(applySpeedAdjustment))
    let speedLabel = UILabel()
    
    let defaultSpeed = 1.0
    let maxSpeed = 1.75
    let minSpeed = 0.25
    let step = 0.25
    
    var currentSpeed: Double = 1.0 {
        didSet {
            speedLabel.text = "speed".localized(with: currentSpeed)
            slowDownItem.isEnabled = isSlowDownEnabled
            speedUpItem.isEnabled = isSpeedUpEnabled
            doneItem.isEnabled = currentSpeed != defaultSpeed
        }
    }
    
    var isSpeedUpEnabled: Bool {
        currentSpeed < maxSpeed
    }
    
    var isSlowDownEnabled: Bool {
        currentSpeed > minSpeed
    }
    
    init(url: URL, didFinishWithVideoURL completion: @escaping (Result<URL, AVAssetExportSession.Error>) -> Void) {
        self.completion = completion
        asset = AVURLAsset(url: url)
        videoViewController = VideoViewController(asset: asset)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(videoViewController.view)
        view.addSubview(toolBar)
        
        setUpVideoViewController()
        setUpToolBar()
        setUpSpeedLabel()
        currentSpeed = defaultSpeed
    }
    
    // 메모리 정리
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpToolBar() {
        func spacer() -> UIBarButtonItem {
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        let cancelItem = getBarButtonItem("multiply", action: #selector(cancelAdjustment))
        
        let items = [cancelItem, spacer(), slowDownItem, spacer(), speedUpItem, spacer(), doneItem]
        slowDownItem.isEnabled = isSlowDownEnabled
        speedUpItem.isEnabled = isSpeedUpEnabled
        
        toolBar.setItems(items, animated: false)
        
        toolBar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(44)
        }
    }
    
    private func getBarButtonItem(_ imageName: String, action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: action
        )
    }
    
    private func setUpSpeedLabel() {
        let speedValueView = ParameterValueView(label: speedLabel)
        view.addSubview(speedValueView)
        
        speedValueView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
    }

    private func setUpVideoViewController() {
        videoViewController.view.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(toolBar.snp.top)
        }
    }

    func getSpeedMode(_ speed: Double) -> SpeedMode {
        if speed > defaultSpeed {
            let scale = Int64((speed - defaultSpeed) / step)
            return .speedUp(scale: scale)
        } else {
            let scale = Int64((defaultSpeed - speed) / step)
            return .slowDown(scale: scale)
        }
    }

    private func updatePlayerRate() {
        videoViewController.setPlayerRate(Float(currentSpeed))
    }

    @objc private func cancelAdjustment() {
        dismiss(animated: true, completion: nil)
    }

    @objc func speedUp() {
        guard isSpeedUpEnabled else { return }
        currentSpeed += step
        updatePlayerRate()
    }

    @objc func slowDown() {
        guard isSlowDownEnabled else { return }
        currentSpeed -= step
        updatePlayerRate()
    }
    
    @objc private func applySpeedAdjustment() {
        guard let playerItem = videoViewController.player.currentItem,
              let assetWithAdjustedSpeed = playerItem.asset.adjustedSpeed(mode: getSpeedMode(currentSpeed)),
              let session = VideoEditor.exportSession(asset: assetWithAdjustedSpeed) else {
            dismiss(animated: true) {
                self.completion(.failure(.unknown))
            }
            return
        }
        videoViewController.isActivityIndicatorVisible = true
        session.export { result in
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.completion(result)
                }
            }
        }
    }
}
