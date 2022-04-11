import Foundation
import YumemiWeather

extension YumemiWeatherError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidParameterError:
            return NSLocalizedString("Parameters are invalid.", comment: "YumemiWeatherError")
        case .unknownError:
            return NSLocalizedString("An unknown error occurred.", comment: "YumemiWeatherError")
        }
    }
}
