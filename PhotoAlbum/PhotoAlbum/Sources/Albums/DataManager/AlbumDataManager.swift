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
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: PHFetchOptions())
 
        for i in 0 ..< cameraRoll.count {
        
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(in: cameraRoll[i], options: fetchOption)
            
            let album = AlbumInfo(title: cameraRoll[i].localizedTitle ?? "무제", count: fetchResult.count, thumnail: fetchResult.firstObject, images: fetchResult)

            viewController.albums.append(album)
            
        }
        
        
        DispatchQueue.main.async {
            viewController.albumTableView.reloadData()
        }
        
    }
    
}
