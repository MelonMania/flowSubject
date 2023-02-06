# [마드라스체크 iOS 개발자 과제]

                                                  지원자 : 이우진

## 🛠️ Tool

- Xcode  // 14.2
- Swift // 5.7.2

## 📌 **Trouble Shooting**

앨범 내부 이미지들을 볼 때 scroll을 매우 빠르게 하면 이미지가 깜박거리고 위치가 바뀜

### 해결방안
- 이미지 캐싱을 하자
- 셀을 재사용 할 때 셀 초기화를 하자

<br>

✅ **이미지 캐싱을 하자**
- UICollectionViewDataSourcePrefetching을 이용해 이미지를 미리 캐싱 해두기
- 캐싱은 PHCachingImageManager를 이용한다

```swift
//MARK: - UICollectionViewDataSourcePrefetching >> prefetch를 이용한 이미지 캐싱
extension PhotoListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat // 이미지 화질 개선
    
        if let value = album?.images {
            DispatchQueue.main.async {
                self.imageManager.startCachingImages(for: indexPaths.map{ value.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: options) // 이미지 캐싱
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat // 이미지 화질 개선
        
        if let value = album?.images {
            DispatchQueue.main.async {
                self.imageManager.stopCachingImages(for: indexPaths.map{ value.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: options) // 캐시 해제
            }
        }
    }
}
```

<br>

✅ **셀을 재사용 할 때 셀 초기화를 하자**

![cellReuse](https://user-images.githubusercontent.com/25768897/217047863-7e79df9a-0704-4470-b4d0-0b25c6b0b635.png)

[셀 재사용 과정]

cellForRowAt, 하단에 셀을 보이기 직전에 prepareForReuse() 메서드가 실행된다.

**따라서**, **prepareForReuse() 메소드를 이용하여 셀을 초기화 하자**

```swift
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
```
