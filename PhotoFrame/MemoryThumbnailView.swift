import SwiftUI
import Photos

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
