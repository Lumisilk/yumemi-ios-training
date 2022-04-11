import UIKit

/// A namespace for weather's properties and assistant functions.
enum Weather {
    
    /// Return the weather icon image using the weather's name if the icon file exists.
    static func icon(for weather: String) -> UIImage? {
        let image = UIImage(named: "icon-\(weather)")
        switch weather {
        case "sunny":
            return image?.withTintColor(.systemRed)
        case "cloudy":
            return image?.withTintColor(.systemGray)
        case "rainy":
            return image?.withTintColor(.systemBlue)
        default:
            return image
        }
    }
}
