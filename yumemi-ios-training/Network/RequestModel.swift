import Foundation

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

struct AreaWeatherRequest: Codable, Equatable {
    let areas: [String]
    let date: Date
}
