import Photos
import UIKit
import Then
import SnapKit

final class ExportViewController: UIViewController {
    typealias Callback = (ExportAction) -> Void
    var saveCopyButton = ShaloSaveCopyVideoButton()
    var shareButton = ShaloSaveCopyVideoButton()
    let shareStackView = UIStackView()
    let saveCopyStackView = UIStackView()
    let exportPanel = UIView().then {
        $0.backgroundColor = .white
    }
    var didTapExportViewButton: Callback?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(exportPanel)
        setUpShareStackView()
        setUpSaveCopyStackView()
        setUpShareButton()
        setUpSaveCopyButton()
        setUpExportView()
    }
    
    func setUpShareStackView() {
        setUpStackView(
            stackView: shareStackView,
            imageName: "square.and.arrow.up",
            headerText: "share".localized(),
            bodyText: "Post your video to a social media site, or send it by e-mail or SMS.".localized()
        )
    }
    
    private func setUpSaveCopyStackView() {
        setUpStackView(
            stackView: saveCopyStackView,
            imageName: "doc.on.doc",
            headerText: "Save a copy".localized(),
            bodyText: "Create a copy to the album.".localized()
        )
    }
    
    private func setUpShareButton() {
        setUpButton(
            stackView: shareStackView,
            button: shareButton,
            action: #selector(self.openActivityView)
        )
    }
    
    private func setUpSaveCopyButton() {
        setUpButton(
            stackView: saveCopyStackView,
            button: saveCopyButton,
            action: #selector(self.saveVideoCopy)
        )
    }
    
    private func setUpExportView() {
        exportPanel.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let exportStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }
        exportPanel.addSubview(exportStackView)
        
        exportStackView.snp.makeConstraints {
            $0.edges.equalTo(exportPanel)
        }
        exportStackView.addArrangedSubviews(shareStackView, saveCopyStackView)
    }
    
    private func setUpStackView(stackView: UIStackView, imageName: String, headerText: String, bodyText: String) {
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        
        let imageView = ShaloImageView(systemName: imageName)
        
        let header = ShaloHeaderLabel(text: headerText)
        let body = ShaloBodyLabel(text: bodyText)
        
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        let labelsStackView = UIStackView().then {
            $0.axis = .vertical
            $0.layoutMargins = .init(top: 8, left: 0, bottom: 8, right: 0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        stackView.addArrangedSubviews(leftSpacer,
                                      imageView,
                                      labelsStackView,
                                      rightSpacer
        )
        
        stackView.setCustomSpacing(0, after: leftSpacer)
        stackView.setCustomSpacing(0, after: labelsStackView)
        
        leftSpacer.snp.makeConstraints {
            $0.width.equalTo(16)
        }

        rightSpacer.snp.makeConstraints {
            $0.width.equalTo(leftSpacer)
        }

        imageView.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        labelsStackView.addArrangedSubviews(header, body)
    }
    
    private func setUpButton(
        stackView: UIStackView,
        button: UIButton,
        action: Selector
    ) {
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(stackView)
        }
    }
    
    @objc func openActivityView() {
        didTapExportViewButton?(.openActivityView)
    }
    
    @objc func saveVideoCopy() {
        didTapExportViewButton?(.saveVideoCopy)
    }
}
