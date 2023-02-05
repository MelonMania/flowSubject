//
//  AlbumDataManager.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import Foundation
import Photos


class AlbumDataManager : AlbumDataManagerDelegate {
    
    func checkPhotosPermission(delegate : AlbumViewDelegate) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("사진 접근 권한 인증 완료")
            self.requestAlbums(delegate : delegate)
            
        case .denied:
            print("사진 접근 권한 거절")
            
        case .notDetermined:
            print("사진 접근 권한 미결정 상태")
            PHPhotoLibrary.requestAuthorization() {
                (status) in
                switch status {
                case .authorized:
                    print("허가")
                    self.requestAlbums(delegate : delegate)
                case .denied:
                    print("거절")
                    break
                default:
                    break
                }
            }
            
        case .restricted:
            print("거절")
        default:
            break
        }
    }
    
    func requestAlbums(delegate : AlbumViewDelegate) {
        
        var albums : [AlbumInfo] = []
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: PHFetchOptions())
        
        for i in 0 ..< cameraRoll.count {
            
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(in: cameraRoll[i], options: fetchOption)
            
            let album = AlbumInfo(title: cameraRoll[i].localizedTitle ?? "무제", count: fetchResult.count, thumnail: fetchResult.firstObject, images: fetchResult)
            
            albums.append(album)
        }
        
        delegate.getAlbum(albums: albums)
    }
    
}
