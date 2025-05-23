import SwiftUI

struct WeatherView: View {
    let weather: Weather
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: weather.iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(weather.location)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.white)
                
                Text("\(Int(weather.temperature))°C")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.white)
                
                Text(weather.description)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(15)
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct Weather {
    let temperature: Double
    let description: String
    let iconName: String
    let location: String
}
