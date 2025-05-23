import Foundation
import CoreLocation

class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeather: Weather?
    
    private let locationManager = CLLocationManager()
    private var updateTimer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // 每30分钟更新一次天气
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            self?.updateWeather()
        }
    }
    
    func requestLocationAndWeather() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // 使用模拟天气数据
            print("Location access denied")
            useMockWeatherData()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        Task {
            await fetchWeather(for: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        useMockWeatherData()
    }
    
    // MARK: - Weather Fetching
    
    private func fetchWeather(for location: CLLocation) async {
        // 获取地理位置名称
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let cityName = placemarks.first?.locality ?? "未知位置"
            
            // 使用OpenWeatherMap API（需要API密钥）或使用模拟数据
            // 这里暂时使用模拟数据，您可以后续集成真实的天气API
            await MainActor.run {
                self.currentWeather = Weather(
                    temperature: 22.5,
                    description: "晴朗",
                    iconName: "sun.max.fill",
                    location: cityName
                )
            }
            
            // 如果您想使用真实天气数据，可以：
            // 1. 注册OpenWeatherMap获取免费API密钥
            // 2. 使用下面的代码（取消注释并替换YOUR_API_KEY）
            /*
            let apiKey = "YOUR_API_KEY"
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&lang=zh_cn"
            
            if let url = URL(string: urlString) {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    
                    if let main = json?["main"] as? [String: Any],
                       let temp = main["temp"] as? Double,
                       let weatherArray = json?["weather"] as? [[String: Any]],
                       let weather = weatherArray.first,
                       let description = weather["description"] as? String {
                        
                        let iconName = self.getIconName(from: weather["icon"] as? String ?? "")
                        
                        await MainActor.run {
                            self.currentWeather = Weather(
                                temperature: temp,
                                description: description,
                                iconName: iconName,
                                location: cityName
                            )
                        }
                    }
                } catch {
                    print("Weather API error: \(error)")
                    self.useMockWeatherData(cityName: cityName)
                }
            }
            */
            
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            useMockWeatherData()
        }
    }
    
    private func useMockWeatherData(cityName: String = "北京") {
        DispatchQueue.main.async {
            // 根据当前时间生成不同的模拟天气
            let hour = Calendar.current.component(.hour, from: Date())
            let isNight = hour < 6 || hour > 18
            
            let weatherConditions = [
                ("晴朗", isNight ? "moon.fill" : "sun.max.fill", 20.0),
                ("多云", "cloud.fill", 18.0),
                ("阴天", "smoke.fill", 16.0),
                ("小雨", "cloud.drizzle.fill", 15.0)
            ]
            
            let randomWeather = weatherConditions.randomElement() ?? weatherConditions[0]
            
            self.currentWeather = Weather(
                temperature: randomWeather.2 + Double.random(in: -5...5),
                description: randomWeather.0,
                iconName: randomWeather.1,
                location: cityName
            )
        }
    }
    
    private func updateWeather() {
        locationManager.requestLocation()
    }
    
    private func getIconName(from iconCode: String) -> String {
        // OpenWeatherMap图标代码转换
        switch iconCode {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n", "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
