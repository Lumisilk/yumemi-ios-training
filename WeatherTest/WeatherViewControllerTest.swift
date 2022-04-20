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
    
    func fetchWeather(area: String, date: Date) -> Result<Weather, Error> {
        do {
            return .success(try onFetchWeather(area, date))
        } catch {
            return .failure(error)
        }
    }
}

class WeatherViewControllerTest: XCTestCase {

    func testSunnyIcon() throws {
        let expectation = self.expectation(description: "WeatherLoading")
        let weatherModel = MockWeatherModel { _, date in
            defer {
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            return Weather(name: "sunny", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        wait(for: [expectation], timeout: 5)
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-sunny")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemRed)
    }
    
    func testRainyIcon() throws {
        let expectation = self.expectation(description: "WeatherLoading")
        let weatherModel = MockWeatherModel { _, date in
            defer {
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            return Weather(name: "rainy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        wait(for: [expectation], timeout: 5)
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-rainy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemBlue)
    }
    
    func testCloudyIcon() throws {
        let expectation = self.expectation(description: "WeatherLoading")
        let weatherModel = MockWeatherModel { _, date in
            defer {
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            return Weather(name: "cloudy", maxTemperature: 28, minTemperature: 1, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        wait(for: [expectation], timeout: 5)
        
        let renderedImageData = viewController.weatherIconView.image?.pngData()
        let expectedImageData = UIImage(named: "icon-cloudy")?.pngData()
        XCTAssertNotNil(renderedImageData)
        XCTAssertNotNil(expectedImageData)
        XCTAssertEqual(renderedImageData, expectedImageData)
        XCTAssertEqual(viewController.weatherIconView.tintColor, .systemGray)
    }
    
    func testTemperatureLabel() throws {
        let expectation = self.expectation(description: "WeatherLoading")
        let weatherModel = MockWeatherModel { _, date in
            defer {
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            return Weather(name: "rainy", maxTemperature: 514, minTemperature: -114, date: date)
        }
        let viewController = WeatherViewController(weatherModel: weatherModel)
        viewController.reloadWeather()
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(viewController.minTemperatureLabel.text, "-114")
        XCTAssertEqual(viewController.maxTemperatureLabel.text, "514")
    }
}
