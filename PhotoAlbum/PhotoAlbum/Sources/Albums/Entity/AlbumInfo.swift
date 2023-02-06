//
//  AlbumInfo.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

struct AlbumInfo {
    var title : String // 앨범 제목
    var count: Int // 앨범 내부 사진 갯수
    
    var thumnail : PHAsset? // 앨범 썸네일
    var images : PHFetchResult<PHAsset>? // 앨범 내부 사진들
}
