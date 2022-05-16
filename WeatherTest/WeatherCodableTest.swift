import XCTest
@testable import yumemi_ios_training

class WeatherCodableTest: XCTestCase {
    
    func testWeatherRequestCodable() throws {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let date = DateComponents(
            calendar: calendar,
            year: 2020,
            month: 4,
            day: 1,
            hour: 12
        ).date!
        
        let weatherRequest = WeatherRequest(area: "tokyo", date: date)
        let encodedData = try WeatherClient.encoder.encode(weatherRequest)
        let decodedRequest = try WeatherClient.decoder.decode(WeatherRequest.self, from: encodedData)
        
        XCTAssertEqual(weatherRequest, decodedRequest)
    }
    
    func testWeatherResponseDecodable() throws {
        let weatherResponseData = """
            {"max_temp":25,"date":"2020-04-01T12:00:00+09:00","min_temp":7,"weather":"cloudy"}
        """.data(using: .utf8)!
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let date = DateComponents(
            calendar: calendar,
            year: 2020,
            month: 4,
            day: 1,
            hour: 12
        ).date!
        let expectedWeather = Weather(name: "cloudy", maxTemperature: 25, minTemperature: 7, date: date)
        let decodedWeather = try WeatherClient.decoder.decode(Weather.self, from: weatherResponseData)
        
        XCTAssertEqual(decodedWeather, expectedWeather)
    }
}
