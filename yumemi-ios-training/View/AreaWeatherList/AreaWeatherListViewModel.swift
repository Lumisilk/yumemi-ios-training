import Combine
import Foundation
import YumemiWeather

class AreaWeatherListViewModel: AreaWeatherListViewModelProtocol {
    
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let areaWeathers = CurrentValueSubject<[AreaWeather], Never>([])
    let error = PassthroughSubject<Error, Never>()
    
    let client: WeatherClient
    
    init(client: WeatherClient = WeatherClient()) {
        self.client = client
    }
    
    func requestAreaWeather(areas: [Area], date: Date) {
        Task {
            isLoading.send(true)
            do {
                self.areaWeathers.send(try await client.requestAreaWeather(areas: areas, date: date))
            } catch {
                self.error.send(error)
            }
            isLoading.send(false)
        }
    }
}
