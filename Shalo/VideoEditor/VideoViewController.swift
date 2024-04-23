import AVFoundation
import UIKit
import SnapKit
import Then

final class VideoViewController: UIViewController {
    private typealias AssetReadinessCompletion = () -> Void
    
    private(set) var asset: AVURLAsset
    let player: AVPlayer

    let playerView: VideoView
    let backgroundVideoView: VideoView
    let activityIndicator = UIActivityIndicatorView().then {
        $0.color = .systemBlue
        $0.hidesWhenStopped = true
        $0.style = .large
    }
    private var assetReadinessCompletion: AssetReadinessCompletion?
    
    lazy var tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    var isActivityIndicatorVisible: Bool = false {
        didSet {
            setActivityIndicatorVisible(isActivityIndicatorVisible)
        }
    }
    
    init(asset: AVURLAsset) {
        self.asset = asset
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        let playerItem = AVPlayerItem(asset: asset).then {
            $0.add(output)
            $0.add(outputBG)
        }
        player = AVPlayer(playerItem: playerItem)
        playerView = VideoView(
            videoOutput: output,
            videoOrientation: asset.videoOrientation
        )
        backgroundVideoView = VideoView(
            videoOutput: outputBG,
            videoOrientation: asset.videoOrientation,
            contentsGravity: .resizeAspectFill,
            filter: BlurFilter(blurRadius: 100)
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundVideoView)
        view.addSubview(playerView)
        setUpBackgroundView()
        setUpPlayerView()
        setUpPlayer()
        setUpResumeButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpBackgroundView() {
        backgroundVideoView.translatesAutoresizingMaskIntoConstraints = false
        view.snp.makeConstraints {
            $0.leading.equalTo(backgroundVideoView.snp.leading)
            $0.trailing.equalTo(backgroundVideoView.snp.trailing)
            $0.bottom.equalTo(backgroundVideoView.snp.bottom)
            $0.top.equalTo(backgroundVideoView.snp.top)
        }
    }
    
    func setUpPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
        }
        playerView.addGestureRecognizer(tap)
    }
    
    private func setActivityIndicatorVisible(_ isOn: Bool) {
        tap.isEnabled = !isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func setUpResumeButton() {
        let stackView = UIStackView(arrangedSubviews: [activityIndicator]).then {
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
        }
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setUpPlayer() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    func setPlayerRate(_ rate: Float) {
        player.rate = rate
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    func setAsset(_ asset: AVURLAsset, completion: @escaping () -> Void) {
        self.asset = asset
        assetReadinessCompletion = completion
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        
        player.replaceCurrentItem(with: playerItem)
        let output = AVPlayerItemVideoOutput(outputSettings: nil)
        let outputBG = AVPlayerItemVideoOutput(outputSettings: nil)
        playerItem.add(output)
        playerItem.add(outputBG)

        playerView.videoOutput = output
        backgroundVideoView.videoOutput = outputBG
    }
    
    // KVO를 통해 플레이어 아이템의 상태 변경을 관찰하는 함수
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if let playerItem = object as? AVPlayerItem,
           keyPath == "status" {
            switch playerItem.status {
            case .readyToPlay:
                assetReadinessCompletion?()
                assetReadinessCompletion = nil
            default:
                break
            }
        }
    }
}
