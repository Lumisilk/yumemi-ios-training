//
//  AreaWeathers.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/22.
//

import Foundation
import YumemiWeather

struct AreaWeather: Codable {
    let area: Area
    let info: Weather
}
