import Foundation
import YumemiWeather

final class WeatherClient {
    
    func fetchWeather(area: String, date: Date = Date()) throws -> Weather {
        let request = WeatherRequest(area: area, date: date)
        let requestData = try WeatherClient.encoder.encode(request)
        if let requestString = String(data: requestData, encoding: .utf8) {
            let reponseString = try YumemiWeather.fetchWeather(requestString)
            if let reponseData = reponseString.data(using: .utf8) {
                return try WeatherClient.decoder.decode(Weather.self, from: reponseData)
            }
        }
        throw YumemiWeatherError.unknownError
    }
}

extension WeatherClient {
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
}
