//
//  AlbumDataManager.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import Foundation
import Photos



struct AlbumDataManager {
    
    func requestPhotosPermission(viewController : AlbumViewController) {
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
        case .authorized:
            print("Photo Authorization status is authorized.")
            self.requestAlbums(viewController: viewController)
            
        case .denied:
            print("Photo Authorization status is denied.")
            
        case .notDetermined:
            print("Photo Authorization status is not determined.")
            PHPhotoLibrary.requestAuthorization() {
                (status) in
                switch status {
                case .authorized:
                    print("User permiited.")
                    self.requestAlbums(viewController: viewController)
                case .denied:
                    print("User denied.")
                    break
                default:
                    break
                }
            }
            
        case .restricted:
            print("Photo Authorization status is restricted.")
        default:
            break
        }
    }
    
    func requestAlbums(viewController : AlbumViewController) {
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        for i in 0 ..< cameraRoll.count {
            var album : AlbumInfo?
            
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(in: cameraRoll[i], options: fetchOption)
            
            album?.title = cameraRoll[0].localizedTitle!
            album?.count = fetchResult.count
            album?.thumnail = fetchResult.firstObject!
            album?.images = fetchResult
            
            if let value = album {
                viewController.albums.append(value)
            }
            
        }
        
        viewController.albumTableView.reloadData()
    }
    
}
