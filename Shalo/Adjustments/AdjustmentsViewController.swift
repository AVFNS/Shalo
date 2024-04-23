import UIKit
import AVFoundation
import Photos
import SnapKit
import Then

final class AdjustmentsViewController<SelectedTool: Tool>: UIViewController {
    let toolBar = UIToolbar(
        frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44))
    ).then {
        $0.tintColor = .darkGray
    }

    let asset: AVURLAsset
    var tool: SelectedTool {
        didSet {
            videoViewController.playerView.filter = tool.filter
        }
    }
    
    let videoViewController: VideoViewController
    let sliderView: TopSliderView
    
    let completion: (Result<URL, AVAssetExportSession.Error>) -> Void
    
    var previousTranslation: CGPoint = .zero
    var isVerticalPan = false
    
    lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture)
    )
    
    init(
        url: URL,
        tool: SelectedTool,
        completion: @escaping (Result<URL, AVAssetExportSession.Error>) -> Void
    ) {
        self.completion = completion
        asset = AVURLAsset(url: url)
        self.tool = tool
        videoViewController = VideoViewController(asset: asset)
        
        let names = tool.allParameters.map(\.description)
        let values = tool.allParameters.map(tool.value)
        let minValues = tool.allParameters.map(tool.minValue)

        sliderView = TopSliderView(
            name: names.first ?? "",
            value: values.first ?? 0.0,
            minPercent: minValues.first ?? 0.0
        )
        
        super.init(nibName: nil, bundle: nil)
        
        videoViewController.playerView.filter = tool.filter
        
        sliderView.didChangeValue = { [weak self] value in
            self?.setValueForSelectedParameter(value)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([videoViewController.view,
                          sliderView,
                          toolBar])
        
        setUpVideoViewController()
        setUpSliderView()
        setUpToolBar()
        setUpPanGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpSliderView() {
        sliderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
    }

    private func setUpToolBar() {
        
        func spacer() -> UIBarButtonItem {
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        let cancelItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(cancelAdjustment))
        let doneItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(applyAdjustment))
        
        let items = [cancelItem, spacer(), spacer(), doneItem]
        toolBar.setItems(items, animated: false)
        
        toolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(44)
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
    
    private func setUpPanGestureRecognizer() {
        videoViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: videoViewController.view)
        
        if recognizer.state == .began {
            let velocity = recognizer.velocity(in: self.view)
            isVerticalPan = abs(velocity.y) > abs(velocity.x)
        }
        if isVerticalPan {
            updateParameterList(translation: translation, state: recognizer.state)
        } else {
            updateSlider(translation: translation, state: recognizer.state)
        }
    }
    
    private func setValueForSelectedParameter(_ value: Double) {
        guard let parameter = SelectedTool.Parameter(string: sliderView.name) else { return }
        tool.setValue(value: value, for: parameter)
    }
    
    private func updateParameterList(translation: CGPoint, state: UIGestureRecognizer.State) {
        previousTranslation.y = translation.y
        
        switch state {
        case .ended:
            previousTranslation = .zero
        default: break
        }
    }
    
    private func updateSlider(translation: CGPoint, state: UIGestureRecognizer.State) {
        let deltaX = previousTranslation.x - translation.x
        previousTranslation.x = translation.x
        sliderView.setDelta(deltaX)
        
        if state == .ended {
            previousTranslation = .zero
        }
    }
    
    @objc private func cancelAdjustment() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyAdjustment() {
        videoViewController.isActivityIndicatorVisible = true
        guard let playerItem = videoViewController.player.currentItem else { return }
        
        VideoEditor
            .exportSession(filter: tool.filter, asset: playerItem.asset)?
            .export { result in
                DispatchQueue.main.async {
                    self.completion(result)
                }
            }
    }
}
