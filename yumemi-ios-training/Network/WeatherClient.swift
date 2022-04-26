import Foundation
import YumemiWeather

final class WeatherClient {
    
    func requestWeather(area: String, date: Date) async throws -> Weather {
        let request = WeatherRequest(area: area, date: date)
        let requestData = try WeatherClient.encoder.encode(request)
        guard let requestString = String(data: requestData, encoding: .utf8) else {
            throw YumemiWeatherError.unknownError
        }
        let responseString = try await YumemiWeather.asyncFetchWeather(requestString)
        guard let responseData = responseString.data(using: .utf8) else {
            throw YumemiWeatherError.unknownError
        }
        return try WeatherClient.decoder.decode(Weather.self, from: responseData)
    }
    
    func requestAreaWeather(areas: [Area], date: Date) async throws -> [AreaWeather] {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let request = AreaWeatherRequest(areas: areas.map(\.rawValue), date: date)
                let requestData = try WeatherClient.encoder.encode(request)
                guard let requestString = String(data: requestData, encoding: .utf8) else {
                    continuation.resume(with: .failure(YumemiWeatherError.unknownError))
                    return
                }
                let responseString = try YumemiWeather.syncFetchWeatherList(requestString)
                guard let responseData = responseString.data(using: .utf8) else {
                    continuation.resume(with: .failure(YumemiWeatherError.unknownError))
                    return
                }
                let areaWeathers = try WeatherClient.decoder.decode([AreaWeather].self, from: responseData)
                continuation.resume(with: .success(areaWeathers))
            } catch {
                continuation.resume(with: .failure(error))
            }
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
