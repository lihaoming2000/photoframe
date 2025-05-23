import SwiftUI
import Photos

struct AlbumPickerView: View {
    @Binding var selectedAlbum: PHAssetCollection?
    @Binding var showAlbumPicker: Bool
    @EnvironmentObject var photoManager: PhotoManager
    
    let columns = [
        GridItem(.adaptive(minimum: 200), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(photoManager.albums, id: \.localIdentifier) { album in
                        AlbumThumbnailView(album: album) {
                            selectedAlbum = album
                            showAlbumPicker = false
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("选择相册")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AlbumThumbnailView: View {
    let album: PHAssetCollection
    let action: () -> Void
    @State private var thumbnailImage: UIImage?
    @State private var photoCount: Int = 0
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                // 相册缩略图
                if let image = thumbnailImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .cornerRadius(10)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                }
                
                // 相册信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.localizedTitle ?? "未命名相册")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("\(photoCount) 张照片")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 5)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            loadAlbumInfo()
        }
    }
    
    private func loadAlbumInfo() {
        // 获取相册中的照片数量
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
        photoCount = assets.count
        
        // 获取第一张照片作为缩略图
        if let firstAsset = assets.firstObject {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            
            manager.requestImage(
                for: firstAsset,
                targetSize: CGSize(width: 300, height: 300),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.thumbnailImage = image
                    }
                }
            }
        }
    }
}
