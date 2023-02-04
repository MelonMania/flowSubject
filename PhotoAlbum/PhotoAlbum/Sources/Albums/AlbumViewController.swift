//
//  AlbumViewController.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

class AlbumViewController: UIViewController {

    var albumManager = AlbumDataManager()
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    
    var albums : [AlbumInfo] = []
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
        
        albumManager.requestPhotosPermission(viewController: self)
    }

    // 네비게이션 바 세팅
    func setNavigationBar() {
        self.navigationItem.title = "앨범"
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        self.view.backgroundColor = .systemGray6
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension AlbumViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsTableViewCell") as? AlbumsTableViewCell else { return UITableViewCell() }
        
        if let thumbnail = albums[indexPath.row].thumnail {
            imageManager.requestImage(for: thumbnail, targetSize: CGSize(width: 70, height: 70), contentMode: .aspectFill, options: nil) {
                image, _ in
                cell.thumbnailImageView.image = image
            }
        } else {
            cell.thumbnailImageView.image = UIImage()
        }
        
        
        cell.albumTitleLabel.text = albums[indexPath.row].title
        cell.photoCountLabel.text = String(albums[indexPath.row].count)
        
        cell.albumTitleLabel.sizeToFit()
        cell.photoCountLabel.sizeToFit()
        
        return cell
    }
    
    
    func setTableView() {
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        // 앨범 셀
        let albumCell = UINib(nibName: "AlbumsTableViewCell", bundle: nil)
        albumTableView.register(albumCell, forCellReuseIdentifier: "AlbumsTableViewCell")
    }
    
}
