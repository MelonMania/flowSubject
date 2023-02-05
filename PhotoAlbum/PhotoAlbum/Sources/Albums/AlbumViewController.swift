//
//  AlbumViewController.swift
//  PhotoAlbum
//
//  Created by RooZin on 2023/02/04.
//

import UIKit
import Photos

class AlbumViewController: UIViewController {

    lazy var albumDataManager : AlbumDataManagerDelegate = AlbumDataManager()
    let imageManager : PHCachingImageManager = PHCachingImageManager()
    
    var albums : [AlbumInfo] = []
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.albumDataManager.checkPhotosPermission(delegate: self)
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
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic // 이미지 화질 개선
            
            imageManager.requestImage(for: thumbnail, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PhotoListViewController()
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        vc.album = albums[indexPath.row]
        backBarButtonItem.tintColor = .black

        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setTableView() {
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        // 앨범 셀
        let albumCell = UINib(nibName: "AlbumsTableViewCell", bundle: nil)
        albumTableView.register(albumCell, forCellReuseIdentifier: "AlbumsTableViewCell")
    }
    
}

//MARK: - AlbumViewDelegate
extension AlbumViewController : AlbumViewDelegate {
    func getAlbum(albums : [AlbumInfo]) {
        self.albums = albums
        
        DispatchQueue.main.async {
            self.albumTableView.reloadData()
        }
    }
}
