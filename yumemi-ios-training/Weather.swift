import Foundation
import UIKit
import YumemiWeather

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}

struct WeatherResponse: Decodable {
    let weatherName: String
    let maxTemperature: Int
    let minTemperature: Int
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case weatherName = "weather"
        case maxTemperature = "max_temp"
        case minTemperature = "min_temp"
        case date
    }
}

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
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    static func fetchWeather(area: String, date: Date = Date()) throws -> WeatherResponse {
        let request = WeatherRequest(area: area, date: date)
        let data = try encoder.encode(request)
        if let requestString = String(data: data, encoding: .utf8) {
            let reponseString = try YumemiWeather.fetchWeather(requestString)
            if let reponseData = reponseString.data(using: .utf8) {
                return try decoder.decode(WeatherResponse.self, from: reponseData)
            }
        }
        throw YumemiWeatherError.unknownError
    }
}
