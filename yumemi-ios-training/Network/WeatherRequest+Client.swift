import Foundation
import YumemiWeather

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

final class WeatherClient: WeatherModel {
    
    func fetchWeather(area: String, date: Date) -> Result<Weather, Error> {
        do {
            let request = WeatherRequest(area: area, date: date)
            let requestData = try WeatherClient.encoder.encode(request)
            guard let requestString = String(data: requestData, encoding: .utf8) else {
                return .failure(YumemiWeatherError.unknownError)
            }
            let reponseString = try YumemiWeather.syncFetchWeather(requestString)
            guard let reponseData = reponseString.data(using: .utf8) else {
                return .failure(YumemiWeatherError.unknownError)
            }
            let weather = try WeatherClient.decoder.decode(Weather.self, from: reponseData)
            return .success(weather)
        } catch {
            return .failure(error)
        }
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
