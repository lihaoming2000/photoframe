import SwiftUI

@main
struct PhotoFrameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 防止屏幕锁定
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    // 恢复屏幕锁定
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }
}
