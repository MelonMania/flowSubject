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
    let imageManager : PHCachingImageManager = PHCachingImageManager() // asset으로부터 이미지를 가져오기 위한 객체
    let targetSize = CGSize(width: 300, height: 300)
    
    var albums : [AlbumInfo] = [] // 디바이스 내부 전체 앨범들이 저장될 변수
    
    @IBOutlet weak var albumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.albumDataManager.checkPhotosPermission(delegate: self) // 권한 확인 후 권한 있으면 앨범들 가져오기
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
            options.deliveryMode = .highQualityFormat // 이미지 화질 개선
            
            imageManager.requestImage(for: thumbnail, targetSize: self.targetSize, contentMode: .aspectFill, options: options) { // PHAsset에서 이미지 가져오기
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // 테이블 뷰 세팅
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
    // 앨범들 가져오기
    func getAlbum(albums : [AlbumInfo]) {
        self.albums = albums
        
        DispatchQueue.main.async {
            self.albumTableView.reloadData()
        }
    }
}
