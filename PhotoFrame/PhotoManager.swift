import Foundation
import Photos

class PhotoManager: ObservableObject {
    @Published var albums: [PHAssetCollection] = []
    @Published var memories: [PHAssetCollection] = []
    @Published var photos: [PHAsset] = []
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        checkPhotoLibraryPermission()
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
                if status == .authorized {
                    self?.loadAlbums()
                    self?.loadMemories()
                }
            }
        }
    }
    
    private func checkPhotoLibraryPermission() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == .authorized {
            loadAlbums()
            loadMemories()
        }
    }
    
    func loadAlbums() {
        albums.removeAll()
        
        // 获取用户创建的相册
        let userAlbums = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: nil
        )
        
        // 获取智能相册（如"最近项目"、"收藏"等）
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: nil
        )
        
        // 将相册添加到数组
        let collections = [userAlbums, smartAlbums]
        
        for collection in collections {
            collection.enumerateObjects { [weak self] (album, _, _) in
                // 检查相册是否包含照片
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                let assetCount = PHAsset.fetchAssets(in: album, options: fetchOptions).count
                
                if assetCount > 0 {
                    self?.albums.append(album)
                }
            }
        }
        
        // 按照片数量排序
        albums.sort { album1, album2 in
            let count1 = PHAsset.fetchAssets(in: album1, options: nil).count
            let count2 = PHAsset.fetchAssets(in: album2, options: nil).count
            return count1 > count2
        }
    }
    
    func loadMemories() {
        memories.removeAll()
        
        // 获取 Memories (时刻)
        let moments = PHAssetCollection.fetchAssetCollections(
            with: .moment,
            subtype: .any,
            options: nil
        )
        
        moments.enumerateObjects { [weak self] (memory, _, _) in
            // 检查是否包含照片
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            let assetCount = PHAsset.fetchAssets(in: memory, options: fetchOptions).count
            
            if assetCount > 0 {
                self?.memories.append(memory)
            }
        }
        
        // 按创建日期排序（最新的在前）
        memories.sort { memory1, memory2 in
            let date1 = memory1.startDate ?? Date.distantPast
            let date2 = memory2.startDate ?? Date.distantPast
            return date1 > date2
        }
    }
    
    func loadPhotos(from collection: PHAssetCollection) {
        photos.removeAll()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        
        assets.enumerateObjects { [weak self] (asset, _, _) in
            self?.photos.append(asset)
        }
    }
}
