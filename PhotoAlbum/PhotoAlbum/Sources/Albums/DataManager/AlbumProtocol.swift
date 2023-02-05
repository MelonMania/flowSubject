//
//  AlbumProtocol.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/05.
//

import Foundation

protocol AlbumViewDelegate {
    func getAlbum(albums : [AlbumInfo])
}

protocol AlbumDataManagerDelegate {
    func checkPhotosPermission(delegate : AlbumViewDelegate)
}
