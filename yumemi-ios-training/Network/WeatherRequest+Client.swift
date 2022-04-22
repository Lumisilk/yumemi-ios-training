import Combine
import Foundation
import YumemiWeather

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

final class WeatherClient: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    func requestWeather(area: String, date: Date) {
        isLoading.send(true)
        DispatchQueue.global().async { [weak self] in
            defer {
                self?.isLoading.send(false)
            }
            do {
                let request = WeatherRequest(area: area, date: date)
                let requestData = try WeatherClient.encoder.encode(request)
                guard let requestString = String(data: requestData, encoding: .utf8) else {
                    self?.delegate?.didReceiveWeather(result: .failure(YumemiWeatherError.unknownError))
                    return
                }
                let reponseString = try YumemiWeather.syncFetchWeather(requestString)
                guard let reponseData = reponseString.data(using: .utf8) else {
                    self?.delegate?.didReceiveWeather(result: .failure(YumemiWeatherError.unknownError))
                    return
                }
                let weather = try WeatherClient.decoder.decode(Weather.self, from: reponseData)
                self?.delegate?.didReceiveWeather(result: .success(weather))
            } catch {
                self?.delegate?.didReceiveWeather(result: .failure(error))
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
