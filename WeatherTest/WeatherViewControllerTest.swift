//
//  WeatherViewControllerTest.swift
//  WeatherViewControllerTest
//
//  Created by Zhou Chang on 2022/04/19.
//

import XCTest
@testable import yumemi_ios_training

struct MockWeatherModel: WeatherModel {
    
    var onFetchWeather: (String, Date) throws -> Weather
    
    func fetchWeather(area: String, date: Date) throws -> Weather {
        try onFetchWeather(area, date)
    }
}

class WeatherViewControllerTest: XCTestCase {

    func testSunnyIcon() throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "sunny", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-sunny")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemRed)
    }
    
    func testRainyIcon() throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "rainy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-rainy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemBlue)
    }
    
    func testCloudyIcon() throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "cloudy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-cloudy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemGray)
    }
    
    func testTemperatureLabel() throws {
        let weatherModel = MockWeatherModel { _, date in
            Weather(name: "rainy", maxTemperature: 514, minTemperature: -114, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        
        XCTAssertEqual(viewController.minTemperatureLabel.text, "-114")
        XCTAssertEqual(viewController.maxTemperatureLabel.text, "514")
    }
}
