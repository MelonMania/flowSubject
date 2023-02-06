//
//  AlbumDataManager.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import Foundation
import Photos


class AlbumDataManager : AlbumDataManagerDelegate {
    // 사진 접근 권한 확인
    func checkPhotosPermission(delegate : AlbumViewDelegate) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("사진 접근 권한 인증 완료")
            self.requestAlbums(delegate : delegate) // 앨범 가져오기
            
        case .denied:
            print("사진 접근 권한 거절")
            
        case .notDetermined:
            print("사진 접근 권한 미결정 상태")
            PHPhotoLibrary.requestAuthorization() { // 권한 요청
                (status) in
                switch status {
                case .authorized:
                    print("허가")
                    self.requestAlbums(delegate : delegate) // 앨범 가져오기
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
    
    // 앨범 가져오기
    func requestAlbums(delegate : AlbumViewDelegate) {
        
        var albums : [AlbumInfo] = [] // 디바이스 내부 모든 앨범들을 저장하기 위한 변수
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: PHFetchOptions()) // 카메라롤 컬렉션
        
        for i in 0 ..< cameraRoll.count {
            
            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult = PHAsset.fetchAssets(in: cameraRoll[i], options: fetchOption) // 앨범 내부 사진을 최근 이미지순으로 fetch
            
            let album = AlbumInfo(title: cameraRoll[i].localizedTitle ?? "무제", count: fetchResult.count, thumnail: fetchResult.firstObject, images: fetchResult)
            
            albums.append(album) // AlbumInfo 자료형으로 변경된 album들 저장
        }
        
        delegate.getAlbum(albums: albums)
    }
    
}
