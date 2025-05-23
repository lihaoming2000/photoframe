import Foundation
import CoreLocation
import WeatherKit

class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeather: Weather?
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
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
            // 使用默认位置或显示错误
            print("Location access denied")
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
    }
    
    // MARK: - Weather Fetching
    
    private func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)
            
            // 获取地理位置名称
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let cityName = placemarks.first?.locality ?? "未知位置"
            
            // 更新天气信息
            await MainActor.run {
                self.currentWeather = Weather(
                    temperature: weather.currentWeather.temperature.value,
                    description: weather.currentWeather.condition.description,
                    iconName: self.weatherIcon(for: weather.currentWeather.condition),
                    location: cityName
                )
            }
        } catch {
            print("Weather fetch error: \(error.localizedDescription)")
        }
    }
    
    private func updateWeather() {
        locationManager.requestLocation()
    }
    
    private func weatherIcon(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear, .mostlyClear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy, .mostlyCloudy:
            return "cloud.fill"
        case .foggy:
            return "cloud.fog.fill"
        case .haze:
            return "sun.haze.fill"
        case .windy:
            return "wind"
        case .rain, .drizzle:
            return "cloud.rain.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .snow, .sleet, .flurries:
            return "cloud.snow.fill"
        case .thunderstorms:
            return "cloud.bolt.rain.fill"
        default:
            return "cloud.fill"
        }
    }
}
