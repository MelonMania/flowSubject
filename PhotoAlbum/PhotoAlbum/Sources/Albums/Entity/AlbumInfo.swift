//
//  AlbumInfo.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

struct AlbumInfo {
    var title : String
    var count: Int
    
    var thumnail : PHAsset?
    var images : PHFetchResult<PHAsset>?
}
