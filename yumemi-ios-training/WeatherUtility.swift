//
//  WeatherUtility.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/07.
//

import UIKit

/// Return the weather icon image using the weather's name if the icon file exists.
func icon(for weather: String) -> UIImage? {
    let image = UIImage(named: "icon-\(weather)")?.withRenderingMode(.alwaysTemplate)
    switch weather {
    case "sunny":
        return image?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    case "cloudy":
        return image?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    case "rainy":
        return image?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    default:
        return image
    }
}
