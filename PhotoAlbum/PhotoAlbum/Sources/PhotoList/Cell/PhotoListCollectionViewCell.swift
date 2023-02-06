//
//  PhotoListCollectionViewCell.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    // 셀 재사용을 위한 셀 초기화
    override func prepareForReuse() {
        super.prepareForReuse()

        self.photoImageView.image = nil
    }

}
