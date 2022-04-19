import Foundation
import YumemiWeather

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

final class WeatherClient: WeatherModel {
    
    func fetchWeather(area: String, date: Date) throws -> Weather {
        let request = WeatherRequest(area: area, date: date)
        let requestData = try WeatherClient.encoder.encode(request)
        guard let requestString = String(data: requestData, encoding: .utf8) else {
            throw YumemiWeatherError.unknownError
        }
        let reponseString = try YumemiWeather.fetchWeather(requestString)
        guard let reponseData = reponseString.data(using: .utf8) else {
            throw YumemiWeatherError.unknownError
        }
        return try WeatherClient.decoder.decode(Weather.self, from: reponseData)
    }
}

extension WeatherClient {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
