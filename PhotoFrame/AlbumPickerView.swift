import SwiftUI
import Photos

struct AlbumPickerView: View {
    @Binding var selectedAlbum: PHAssetCollection?
    @Binding var showAlbumPicker: Bool
    @EnvironmentObject var photoManager: PhotoManager
    @State private var selectedTab = 0
    
    let albumColumns = [
        GridItem(.adaptive(minimum: 200), spacing: 20)
    ]
    
    let memoryColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 分段控制器
                Picker("", selection: $selectedTab) {
                    Text("相册").tag(0)
                    Text("回忆").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 内容区域
                if selectedTab == 0 {
                    // 相册视图
                    ScrollView {
                        LazyVGrid(columns: albumColumns, spacing: 20) {
                            ForEach(photoManager.albums, id: \.localIdentifier) { album in
                                AlbumThumbnailView(album: album) {
                                    selectedAlbum = album
                                    showAlbumPicker = false
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    // 回忆视图
                    ScrollView {
                        if photoManager.memories.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("暂无回忆")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("系统会自动创建回忆，请稍后再试")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                        } else {
                            LazyVGrid(columns: memoryColumns, spacing: 20) {
                                ForEach(photoManager.memories, id: \.localIdentifier) { memory in
                                    MemoryThumbnailView(memory: memory) {
                                        selectedAlbum = memory
                                        showAlbumPicker = false
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("选择内容")
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
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
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

// MemoryThumbnailView 组件
struct MemoryThumbnailView: View {
    let memory: PHAssetCollection
    let action: () -> Void
    @State private var coverImages: [UIImage] = []
    @State private var photoCount: Int = 0
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // 背景图片
                if let firstImage = coverImages.first {
                    Image(uiImage: firstImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(15)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                                startPoint: .bottom,
                                endPoint: .center
                            )
                            .cornerRadius(15)
                        )
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .cornerRadius(15)
                }
                
                // 内容覆盖层
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    // 标题
                    Text(memory.localizedTitle ?? "回忆")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    // 日期范围
                    if let startDate = memory.startDate, let endDate = memory.endDate {
                        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
                            Text(dateFormatter.string(from: startDate))
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        } else {
                            Text("\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // 照片数量
                    Text("\(photoCount) 张照片")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(radius: 5)
        .onAppear {
            loadMemoryInfo()
        }
    }
    
    private func loadMemoryInfo() {
        // 获取照片数量
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let assets = PHAsset.fetchAssets(in: memory, options: fetchOptions)
        photoCount = assets.count
        
        // 获取前3张照片作为封面
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        
        let maxImages = min(3, assets.count)
        for i in 0..<maxImages {
            let asset = assets[i]
            manager.requestImage(
                for: asset,
                targetSize: CGSize(width: 400, height: 400),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                if let image = image {
                    DispatchQueue.main.async {
                        self.coverImages.append(image)
                    }
                }
            }
        }
    }
}
