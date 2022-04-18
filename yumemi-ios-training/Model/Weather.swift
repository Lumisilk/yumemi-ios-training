import Foundation

struct Weather: Decodable {
    let name: String
    let maxTemperature: Int
    let minTemperature: Int
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case name = "weather"
        case maxTemperature = "max_temp"
        case minTemperature = "min_temp"
        case date
    }
}
