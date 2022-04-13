import Foundation
import UIKit
import YumemiWeather

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}

struct Weather: Decodable {
    let name: String
    let maxTemperature: Int
    let minTemperature: Int
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case name = "weather"
        case maxTemperature = "max_temp"
        case minTemperature = "min_temp"
        case date
    }
}

extension Weather {
    
    var icon: UIImage? {
        Weather.icon(for: name)
    }
    
    /// Return the weather icon image using the weather's name if the icon file exists.
    static func icon(for weather: String) -> UIImage? {
        guard let image = UIImage(named: "icon-\(weather)") else {
            return nil
        }
        switch weather {
        case "sunny":
            return image.withTintColor(.systemRed)
        case "cloudy":
            return image.withTintColor(.systemGray)
        case "rainy":
            return image.withTintColor(.systemBlue)
        default:
            return image
        }
    }
}
