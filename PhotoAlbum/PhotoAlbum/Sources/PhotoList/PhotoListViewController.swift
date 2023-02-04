//
//  PhotoListViewController.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

class PhotoListViewController: UIViewController {
    
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    var album : AlbumInfo?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
    }
    
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        self.view.backgroundColor = .systemGray6
                
        self.navigationItem.title = album?.title
    }
    
}

extension PhotoListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let value = album {
            return value.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoListCollectionViewCell", for: indexPath) as! PhotoListCollectionViewCell // 이거 guard로 수정 생각
        
        if let photo = album?.images?[indexPath.row] {
            imageManager.requestImage(for: photo, targetSize: CGSize(width: 70, height: 70), contentMode: .aspectFill, options: nil) {
                image, _ in
                cell.photoImageView.image = image
            }
        } else {
            cell.photoImageView.image = UIImage()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 4
        let width: CGFloat = (collectionView.bounds.width - (2 * margin)) / 3
        print("width : \(collectionView.bounds.width)")
        let height: CGFloat = width
        print("height : \(height)")
        
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
            let resources = PHAssetResource.assetResources(for: asset)
            let filename = resources.first!.originalFilename
            
            let alert = UIAlertController(title: "사진정보", message: "파일명 : \(filename)\n파일크기 : ", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
                
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 앨범 셀
        let photoCell = UINib(nibName: "PhotoListCollectionViewCell", bundle: nil)
        collectionView.register(photoCell, forCellWithReuseIdentifier: "PhotoListCollectionViewCell")
    }
    
    
}