import UIKit
import AVKit
import MobileCoreServices
import Then
import SnapKit

final class HomeViewController: UIViewController {
    private let app = App.shared
    private var addVideoButton = UIButton()
    private var videoEditorViewController: VideoEditorViewController?
    
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.numberOfLines = 0
        $0.text = "Please press the background and choose a video".localized()
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    let button = UIButton()
    
    let stackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 32
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navgetionSetup()
        attribute()
        layout()
        buttonAction()
    }
    
    private func navgetionSetup() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.hideHairline()
    }
    
    private func attribute() {
        self.view.backgroundColor = .white
    }
    
    private func layout() {
        stackView.addArrangedSubview(label)
        view.addSubviews([stackView, button])

        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func buttonAction() {
        let openButton = UIBarButtonItem(title: "Open".localized(), style: .plain, target: self, action: #selector(handleAddVideoTap)).then {
            $0.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        }
        navigationItem.leftBarButtonItem = openButton
        
        button.addTarget(self, action: #selector(handleAddVideoTap), for: .touchUpInside)
    }
    
    @objc private func handleAddVideoTap() {
        VideoBrowser.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
    
    private func embed(_ videoEditorVC: VideoEditorViewController) {
        self.videoEditorViewController = videoEditorVC
        addChild(videoEditorVC)
        view.addSubview(videoEditorVC.view)
        videoEditorVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        videoEditorVC.didMove(toParent: self)
        videoEditorVC.view.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videoEditorVC.view.isHidden = false
        }
    }
    
    func removeEmbeddedViewController() {
        guard let childVC = videoEditorViewController else { return }
        childVC.removeFromParent()
        childVC.view.removeFromSuperview()
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
        }
        dismiss(animated: true) {
            self.removeEmbeddedViewController()
            self.embed(VideoEditorViewController(url: url, selectedFilterIndex: 0, filters: self.app.filters, tools: self.app.tools))
        }
    }
}

extension HomeViewController: UINavigationControllerDelegate {}

extension UINavigationController {
    func hideHairline() {
        let hairline = findHairlineImageViewUnder(navigationBar)
        hairline?.isHidden = true
    }

    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}
