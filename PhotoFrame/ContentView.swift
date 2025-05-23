import SwiftUI
import Photos

struct ContentView: View {
    @StateObject private var photoManager = PhotoManager()
    @StateObject private var weatherManager = WeatherManager()
    @State private var selectedAlbum: PHAssetCollection?
    @State private var showAlbumPicker = true
    @State private var currentPhotoIndex = 0
    @State private var timer: Timer?
    @State private var currentDate = Date()
    @State private var opacity: Double = 1.0
    
    let slideInterval: TimeInterval = 5 // 每5秒切换一张照片
    let transitionDuration: Double = 1.0 // 淡入淡出动画时长
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if !showAlbumPicker && !photoManager.photos.isEmpty {
                // 照片展示视图
                if let currentPhoto = photoManager.photos[safe: currentPhotoIndex] {
                    PhotoView(asset: currentPhoto)
                        .opacity(opacity)
                        .ignoresSafeArea()
                }
                
                // 时间和天气信息覆盖层
                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            // 时间显示
                            Text(currentDate, style: .time)
                                .font(.system(size: 48, weight: .light))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            
                            Text(currentDate, style: .date)
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            
                            // 天气信息
                            if let weather = weatherManager.currentWeather {
                                WeatherView(weather: weather)
                            }
                        }
                        .padding(30)
                    }
                    Spacer()
                }
                
                // 控制按钮
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            stopSlideshow()
                            showAlbumPicker = true
                        }) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding()
                        Spacer()
                    }
                }
            } else if showAlbumPicker {
                // 相册选择视图
                AlbumPickerView(selectedAlbum: $selectedAlbum, showAlbumPicker: $showAlbumPicker)
                    .environmentObject(photoManager)
            }
        }
        .onAppear {
            // 请求照片权限
            photoManager.requestPhotoLibraryAccess()
            // 获取天气信息
            weatherManager.requestLocationAndWeather()
            // 更新时间
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentDate = Date()
            }
        }
        .onChange(of: selectedAlbum) { newAlbum in
            if let album = newAlbum {
                photoManager.loadPhotos(from: album)
                startSlideshow()
            }
        }
    }
    
    private func startSlideshow() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: slideInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: transitionDuration)) {
                opacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
                currentPhotoIndex = (currentPhotoIndex + 1) % photoManager.photos.count
                withAnimation(.easeInOut(duration: transitionDuration)) {
                    opacity = 1.0
                }
            }
        }
    }
    
    private func stopSlideshow() {
        timer?.invalidate()
        timer = nil
    }
}

// 安全数组访问扩展
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}
