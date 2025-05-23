# PhotoFrame - iPad相册播放应用

一个专为iPad设计的优雅相册播放应用，支持自动播放、天气显示和时间显示功能。

## 功能特性

- 📸 **相册选择**: 浏览并选择iPad上的任意相册进行播放
- 🎞️ **自动播放**: 照片自动滚动播放，带有优雅的淡入淡出效果
- 🔒 **屏幕常亮**: 应用运行时自动保持屏幕不锁定
- 🕐 **时间显示**: 实时显示当前时间和日期
- 🌤️ **天气信息**: 显示当前位置的天气状况
- 🎨 **全屏显示**: 照片以全屏模式展示，带来沉浸式体验

## 开发环境要求

- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本
- iOS 16.0 或更高版本的iPad

## 项目设置

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

5. **WeatherKit配置**
   - 在Apple Developer账号中启用WeatherKit服务
   - 在项目的Capabilities中添加WeatherKit

## 使用说明

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

## 项目结构

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

## 自定义设置

你可以在 `ContentView.swift` 中修改以下设置：

- `slideInterval`: 照片切换间隔（默认5秒）
- `transitionDuration`: 淡入淡出动画时长（默认1秒）

## 部署选项

### 个人使用（推荐）
1. 连接你的iPad到Mac
2. 在Xcode中选择你的iPad作为运行目标
3. 点击运行按钮安装到你的设备

### App Store发布
如果你想发布到App Store：
1. 需要Apple Developer Program会员资格（$99/年）
2. 在App Store Connect创建应用
3. 提交审核

考虑到这是个人使用的应用，建议使用个人开发者证书直接安装到你的iPad上，这样可以免费使用7天，之后需要重新安装。如果你有Apple Developer账号，可以安装使用一年。

## 技术栈

- **SwiftUI**: 用户界面
- **PhotoKit**: 照片库访问
- **WeatherKit**: 天气信息
- **CoreLocation**: 位置服务

## 注意事项

- 确保iPad有足够的存储空间来缓存照片
- 首次加载大相册可能需要一些时间
- 天气信息需要网络连接

## 许可证

本项目仅供个人使用。

## 联系方式

如有问题，请在GitHub上提交Issue。
