# PhotoFrame - iPad相册播放应用 / iPad Photo Album Player

[中文](#中文) | [English](#english)

---

## 中文

一个专为iPad设计的优雅相册播放应用，支持自动播放、天气显示和时间显示功能。

### 功能特性

- 📸 **相册选择**: 浏览并选择iPad上的任意相册进行播放
- 🎞️ **自动播放**: 照片自动滚动播放，带有优雅的淡入淡出效果
- 🔒 **屏幕常亮**: 应用运行时自动保持屏幕不锁定
- 🕐 **时间显示**: 实时显示当前时间和日期
- 🌤️ **天气信息**: 显示当前位置的天气状况
- 🎨 **全屏显示**: 照片以全屏模式展示，带来沉浸式体验

### 开发环境要求

- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本
- iOS 16.0 或更高版本的iPad

### 项目设置

1. **克隆仓库**
   ```bash
   git clone https://github.com/lihaoming2000/photoframe.git
   cd photoframe
   ```

2. **打开项目**
   - 使用Xcode打开 `PhotoFrame.xcodeproj`

3. **配置开发者账号**
   - 在Xcode中选择你的开发团队
   - 修改Bundle Identifier（建议使用: `com.yourname.photoframe`）

4. **配置权限**
   项目已经配置了以下权限（在Info.plist中）：
   - 照片库访问权限
   - 位置访问权限（用于天气信息）

### 使用说明

1. **首次启动**
   - 应用会请求照片库访问权限
   - 应用会请求位置访问权限（用于显示天气）

2. **选择相册**
   - 启动后会显示相册选择界面
   - 点击任意相册开始播放

3. **播放控制**
   - 照片每5秒自动切换
   - 点击左下角的相册图标可重新选择相册

4. **信息显示**
   - 右上角显示当前时间、日期和天气信息

### 项目结构

```
PhotoFrame/
├── PhotoFrame/
│   ├── PhotoFrameApp.swift        # 应用入口
│   ├── ContentView.swift          # 主视图
│   ├── PhotoView.swift           # 照片显示组件
│   ├── AlbumPickerView.swift     # 相册选择视图
│   ├── WeatherView.swift         # 天气显示组件
│   ├── PhotoManager.swift        # 照片管理器
│   ├── WeatherManager.swift      # 天气管理器
│   └── Info.plist               # 应用配置文件
└── PhotoFrame.xcodeproj/        # Xcode项目文件
```

### 自定义设置

你可以在 `ContentView.swift` 中修改以下设置：

- `slideInterval`: 照片切换间隔（默认5秒）
- `transitionDuration`: 淡入淡出动画时长（默认1秒）

### 天气数据

当前版本使用模拟天气数据。如需真实天气数据，可以：

1. **使用OpenWeatherMap API（免费）**
   - 注册获取API密钥：https://openweathermap.org
   - 在`WeatherManager.swift`中配置API密钥

2. **使用Apple WeatherKit（需要付费开发者账号）**
   - 在Apple Developer中启用WeatherKit
   - 在项目中添加WeatherKit capability

### 部署选项

#### 个人使用（推荐）
1. 连接你的iPad到Mac
2. 在Xcode中选择你的iPad作为运行目标
3. 点击运行按钮安装到你的设备

#### App Store发布
如果你想发布到App Store：
1. 需要Apple Developer Program会员资格（$99/年）
2. 在App Store Connect创建应用
3. 提交审核

考虑到这是个人使用的应用，建议使用个人开发者证书直接安装到你的iPad上，这样可以免费使用7天，之后需要重新安装。如果你有Apple Developer账号，可以安装使用一年。

### 技术栈

- **SwiftUI**: 用户界面
- **PhotoKit**: 照片库访问
- **CoreLocation**: 位置服务
- **URLSession**: 网络请求（天气API）

### 注意事项

- 确保iPad有足够的存储空间来缓存照片
- 首次加载大相册可能需要一些时间
- 天气信息需要网络连接（使用真实API时）

### 许可证

本项目仅供个人使用。

### 联系方式

如有问题，请在GitHub上提交Issue。

---

## English

An elegant photo album player designed specifically for iPad, featuring automatic playback, weather display, and time display.

### Features

- 📸 **Album Selection**: Browse and select any album on your iPad for playback
- 🎞️ **Auto Playback**: Photos automatically scroll with elegant fade transitions
- 🔒 **Screen Always On**: Automatically keeps screen unlocked while app is running
- 🕐 **Time Display**: Real-time display of current time and date
- 🌤️ **Weather Info**: Shows current location weather conditions
- 🎨 **Fullscreen Display**: Photos displayed in fullscreen mode for immersive experience

### Development Requirements

- macOS 12.0 or later
- Xcode 14.0 or later
- iPad with iOS 16.0 or later

### Project Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/lihaoming2000/photoframe.git
   cd photoframe
   ```

2. **Open Project**
   - Open `PhotoFrame.xcodeproj` with Xcode

3. **Configure Developer Account**
   - Select your development team in Xcode
   - Modify Bundle Identifier (suggested: `com.yourname.photoframe`)

4. **Permissions Configuration**
   The following permissions are already configured in Info.plist:
   - Photo Library access
   - Location access (for weather information)

### Usage Instructions

1. **First Launch**
   - App will request photo library access permission
   - App will request location access permission (for weather display)

2. **Select Album**
   - Album selection interface appears on launch
   - Tap any album to start playback

3. **Playback Control**
   - Photos automatically change every 5 seconds
   - Tap the album icon in bottom-left to reselect album

4. **Information Display**
   - Current time, date, and weather info displayed in top-right corner

### Project Structure

```
PhotoFrame/
├── PhotoFrame/
│   ├── PhotoFrameApp.swift        # App entry point
│   ├── ContentView.swift          # Main view
│   ├── PhotoView.swift           # Photo display component
│   ├── AlbumPickerView.swift     # Album picker view
│   ├── WeatherView.swift         # Weather display component
│   ├── PhotoManager.swift        # Photo manager
│   ├── WeatherManager.swift      # Weather manager
│   └── Info.plist               # App configuration
└── PhotoFrame.xcodeproj/        # Xcode project file
```

### Custom Settings

You can modify the following settings in `ContentView.swift`:

- `slideInterval`: Photo transition interval (default: 5 seconds)
- `transitionDuration`: Fade animation duration (default: 1 second)

### Weather Data

Current version uses mock weather data. For real weather data:

1. **Use OpenWeatherMap API (Free)**
   - Register for API key: https://openweathermap.org
   - Configure API key in `WeatherManager.swift`

2. **Use Apple WeatherKit (Requires paid developer account)**
   - Enable WeatherKit in Apple Developer
   - Add WeatherKit capability to project

### Deployment Options

#### Personal Use (Recommended)
1. Connect your iPad to Mac
2. Select your iPad as run target in Xcode
3. Click run button to install on your device

#### App Store Release
To publish on App Store:
1. Requires Apple Developer Program membership ($99/year)
2. Create app in App Store Connect
3. Submit for review

Since this is for personal use, we recommend using a personal developer certificate to install directly on your iPad. This allows free use for 7 days, after which you'll need to reinstall. With an Apple Developer account, you can use it for one year.

### Tech Stack

- **SwiftUI**: User interface
- **PhotoKit**: Photo library access
- **CoreLocation**: Location services
- **URLSession**: Network requests (weather API)

### Notes

- Ensure iPad has sufficient storage for photo caching
- First load of large albums may take some time
- Weather info requires internet connection (when using real API)

### License

This project is for personal use only.

### Contact

For issues, please submit on GitHub.
