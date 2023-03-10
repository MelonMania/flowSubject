//
//  AlbumsTableViewCell.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView! // 앨범 썸네일 ImageView
    @IBOutlet weak var albumTitleLabel: UILabel! // 앨범 제목 Label
    @IBOutlet weak var photoCountLabel: UILabel! // 사진 갯수 Label
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // 셀 재사용을 위한 셀 초기화
    override func prepareForReuse() {
        super.prepareForReuse()

        self.thumbnailImageView.image = nil
        self.albumTitleLabel.text = nil
        self.photoCountLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
