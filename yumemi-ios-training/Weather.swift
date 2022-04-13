import Foundation
import UIKit
import YumemiWeather

/// A namespace for weather's properties and assistant functions.
enum Weather {
    
    /// Return the weather icon image using the weather's name if the icon file exists.
    static func icon(for weather: String) -> UIImage? {
        let image = UIImage(named: "icon-\(weather)")
        switch weather {
        case "sunny":
            return image?.withTintColor(.systemRed)
        case "cloudy":
            return image?.withTintColor(.systemGray)
        case "rainy":
            return image?.withTintColor(.systemBlue)
        default:
            return image
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    static func fetchWeather(
        area: String,
        date: Date = Date()
    ) throws -> (
        minTemperature: Int,
        maxTemperature: Int,
        weatherName: String
    )? {
        let requestString = """
            {
                "area": "\(area)",
                "date": "\(dateFormatter.string(from: date))"
            }
        """
        let jsonResult = try YumemiWeather.fetchWeather(requestString)
        if let data = jsonResult.data(using: .utf8),
           let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let minTemperature = json["min_temp"] as? Int,
           let maxTemperature = json["max_temp"] as? Int,
           let weatherName = json["weather"] as? String {
            return (minTemperature, maxTemperature, weatherName)
        } else {
            return nil
        }
    }
}
