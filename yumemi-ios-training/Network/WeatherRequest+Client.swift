import Combine
import Foundation
import YumemiWeather

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

final class WeatherClient: WeatherModel {
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    func fetchWeather(area: String, date: Date) -> AnyPublisher<Weather, Error> {
        isLoading.send(true)
        return Future<Weather, Error> { [isLoading] promise in
            DispatchQueue.global().async {
                defer {
                    isLoading.send(false)
                }
                do {
                    let request = WeatherRequest(area: area, date: date)
                    let requestData = try WeatherClient.encoder.encode(request)
                    guard let requestString = String(data: requestData, encoding: .utf8) else {
                        promise(.failure(YumemiWeatherError.unknownError))
                        return
                    }
                    let reponseString = try YumemiWeather.syncFetchWeather(requestString)
                    guard let reponseData = reponseString.data(using: .utf8) else {
                        promise(.failure(YumemiWeatherError.unknownError))
                        return
                    }
                    let weather = try WeatherClient.decoder.decode(Weather.self, from: reponseData)
                    promise(.success(weather))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
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
