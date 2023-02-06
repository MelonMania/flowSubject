//
//  PhotoListViewController.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

class PhotoListViewController: UIViewController {
    
    let imageManager : PHCachingImageManager = PHCachingImageManager() // asset으로부터 이미지를 가져오기 위한 객체
    let targetSize = CGSize(width: 300, height: 300)
    
    var album : AlbumInfo?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
    }
    
    // 네비게이션 바 세팅
    func setNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        self.view.backgroundColor = .systemGray6
        
        self.navigationItem.title = album?.title
    }
    
}

extension PhotoListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let value = album?.images {
            return value.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        
        if let photo = self.album?.images?[indexPath.item] {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat // 이미지 화질 개선
            
            imageManager.requestImage(for: photo, targetSize: self.targetSize, contentMode: .aspectFill, options: options, resultHandler: { // 이미지 가져오기
                image, _ in
                cell.photoImageView.image = image
            })
        } else {
            cell.photoImageView.image = UIImage()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 4
        let width: CGFloat = (collectionView.bounds.width - (2 * margin)) / 3
        let height: CGFloat = width
        // 한 줄당 3개의 이미지를 4씩 간격을 두고 나타내기 위함
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = self.album?.images?.object(at: indexPath.row) {
            let resources = PHAssetResource.assetResources(for: asset) // Asset(사진)의 resource 가져오기
            let fileName = resources.first!.originalFilename // 파일이름
            var fileSize = ""
            var sizeOnDisk: Int64 = 0
            
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong // 파일사이즈 가져오기
                
                let formatter : ByteCountFormatter = ByteCountFormatter()
                formatter.countStyle = .file // 파일 바이트 수 표시로 지정
                
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
    
                fileSize = formatter.string(fromByteCount: Int64(sizeOnDisk)) // 가장 적절한 단위로 변환
            }
            
            let alert = UIAlertController(title: "사진정보", message: "파일명 : \(fileName)\n파일크기 : \(fileSize)", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil) // 사진정보 alert창 띄우기
        }
        
    }
    
    // 컬렉션뷰 세팅
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.backgroundColor = .systemGray6
        
        // 앨범 셀
        let photoCell = UINib(nibName: "PhotoListCollectionViewCell", bundle: nil)
        collectionView.register(photoCell, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
    }
    
}

//MARK: - UICollectionViewDataSourcePrefetching >> prefetch를 이용한 이미지 캐싱
extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat // 이미지 화질 개선
    
        if let value = album?.images {
            DispatchQueue.main.async {
                self.imageManager.startCachingImages(for: indexPaths.map{ value.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: options) // 이미지 캐싱
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat // 이미지 화질 개선
        
        if let value = album?.images {
            DispatchQueue.main.async {
                self.imageManager.stopCachingImages(for: indexPaths.map{ value.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: options) // 캐시 해제
            }
        }
    }
}

