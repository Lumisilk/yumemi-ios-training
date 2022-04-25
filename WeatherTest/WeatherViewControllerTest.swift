//
//  WeatherViewControllerTest.swift
//  WeatherViewControllerTest
//
//  Created by Zhou Chang on 2022/04/19.
//

import Combine
import XCTest
@testable import yumemi_ios_training

struct MockWeatherModel: WeatherModel {
    
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var onFetchWeather: (String, Date) throws -> Weather
    
    func requestWeather(area: String, date: Date) async throws -> Weather {
        try await withCheckedThrowingContinuation { continuation in
            do {
                continuation.resume(with: .success(try onFetchWeather(area, date)))
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
}

class WeatherViewControllerTest: XCTestCase {
    
    func testSunnyIcon() async throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "sunny", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = await WeatherViewController(weatherModel: weatherModel)
        await viewController.reloadWeather()
        
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
        let viewController = await WeatherViewController(weatherModel: weatherModel)
        await viewController.reloadWeather()
        
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
        let viewController = await WeatherViewController(weatherModel: weatherModel)
        await viewController.reloadWeather()
        
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
        let viewController = await WeatherViewController(weatherModel: weatherModel)
        await viewController.reloadWeather()
        
        let minTemperatureLabelText = await viewController.minTemperatureLabel.text
        let maxTemperatureLabelText = await viewController.maxTemperatureLabel.text
        
        XCTAssertEqual(minTemperatureLabelText, "-114")
        XCTAssertEqual(maxTemperatureLabelText, "514")
    }
}
