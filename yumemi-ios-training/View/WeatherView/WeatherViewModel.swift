import Combine
import Foundation
import YumemiWeather

class WeatherViewModel: WeatherViewModelProtocol {
    
    let area: Area
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let weather = CurrentValueSubject<Weather?, Never>(nil)
    let error = PassthroughSubject<Error, Never>()
    
    let client: WeatherClient
    
    init(area: Area, weather: Weather? = nil, client: WeatherClient = WeatherClient()) {
        self.area = area
        self.client = client
        self.weather.send(weather)
    }
    
    func requestWeather(date: Date) {
        Task {
            isLoading.send(true)
            do {
                weather.send(try await client.requestWeather(area: area.rawValue, date: date))
            } catch {
                self.error.send(error)
            }
            isLoading.send(false)
        }
    }
}
