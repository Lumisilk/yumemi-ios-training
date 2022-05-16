import Combine
import XCTest
import YumemiWeather
@testable import yumemi_ios_training

struct MockWeatherModel: WeatherViewModelProtocol {
    
    var onFetchWeather: (String, Date) async throws -> Weather
    
    var area: Area = .Tokyo
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var weather = CurrentValueSubject<Weather?, Never>(nil)
    var error = PassthroughSubject<Error, Never>()

    func requestWeather(date: Date) {
        Task {
            self.isLoading.send(true)
            do {
                self.weather.send(try await onFetchWeather(area.rawValue, date))
            } catch {
                self.error.send(error)
            }
            self.isLoading.send(false)
        }
    }
}

class WeatherViewControllerTest: XCTestCase {
    
    var cancellables: [AnyCancellable] = []

    func testSunnyIcon() async throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "sunny", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = await WeatherViewController(weatherViewModel: weatherModel)
        weatherModel.requestWeather(date: Date())
        
        let renderedImageData = await viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-sunny")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        let tintColor = await viewController.weatherIconView.tintColor
        XCTAssertEqual(tintColor, .systemRed)
    }
    
    func testRainyIcon() async throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "rainy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = await WeatherViewController(weatherViewModel: weatherModel)
        weatherModel.requestWeather(date: Date())

        let renderedImageData = await viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-rainy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        let tintColor = await viewController.weatherIconView.tintColor
        XCTAssertEqual(tintColor, .systemBlue)
    }
    
    func testCloudyIcon() async throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "cloudy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = await WeatherViewController(weatherViewModel: weatherModel)
        weatherModel.requestWeather(date: Date())
        
        let renderedImageData = await viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-cloudy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        let tintColor = await viewController.weatherIconView.tintColor
        XCTAssertEqual(tintColor, .systemGray)
    }
    
    func testTemperatureLabel() async throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "rainy", maxTemperature: 514, minTemperature: -114, date: date)
        }
        let viewController = await WeatherViewController(weatherViewModel: weatherModel)
        weatherModel.requestWeather(date: Date())
        
        let minTemperatureLabelText = await viewController.minTemperatureLabel.text
        let maxTemperatureLabelText = await viewController.maxTemperatureLabel.text
        
        XCTAssertEqual(minTemperatureLabelText, "-114")
        XCTAssertEqual(maxTemperatureLabelText, "514")
    }
}
