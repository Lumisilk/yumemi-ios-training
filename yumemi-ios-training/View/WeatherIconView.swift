import UIKit

final class WeatherIconView: UIImageView {
    
    func setIcon(with weatherName: String) {
        image = UIImage(named: "icon-\(weatherName)")?.withRenderingMode(.alwaysTemplate)
        switch weatherName {
        case "sunny":
            tintColor = .systemRed
        case "cloudy":
            tintColor = .systemGray
        case "rainy":
            tintColor = .systemBlue
        default:
            break
        }
    }
}
