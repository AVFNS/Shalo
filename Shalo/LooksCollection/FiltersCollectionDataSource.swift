import UIKit

final class FiltersCollectionDataSource: NSObject, UICollectionViewDataSource {
    static let reusableIdentifier = "FiltersCollectionViewCell"
    
    weak var collectionView: UICollectionView?
    
    let filters: [Filter]
    
    var filteredImages: [String: UIImage] = [:]
    
    var image: UIImage? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    private let context: CIContext
    
    init(collectionView: UICollectionView, filters: [Filter], context: CIContext) {
        self.filters = filters
        self.collectionView = collectionView
        self.context = context
        super.init()
        collectionView.dataSource = self
        collectionView.register(
            FiltersCollectionViewCell.self,
            forCellWithReuseIdentifier: "FiltersCollectionViewCell"
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reusableIdentifier, for: indexPath) as! FiltersCollectionViewCell
        cell.filterName.text = filters[indexPath.row].name
        
        if let filteredImage = filteredImages[filters[indexPath.row].name] {
            cell.previewImageView.image = filteredImage
        } else if let image = image {
            applyFilter(self.filters[indexPath.row], on: image) { [weak self] (filteredImage) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.filteredImages[self.filters[indexPath.row].name] = filteredImage
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        } else {
            cell.previewImageView.image = UIImage(named: "LaunchScreenLogo1")
        }
        
        return cell
    }
    
    func applyFilter(_ filter: Filter, on image: UIImage, callback: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            callback(nil)
            return
        }
        
        DispatchQueue.global().async {
            let ciImage = CIImage(cgImage: cgImage)
            let filteredCIImage = filter.apply(image: ciImage)
            if let filteredCGImage = self.context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
                callback(UIImage(cgImage: filteredCGImage))
            } else {
                callback(nil)
            }
        }
    }
}
