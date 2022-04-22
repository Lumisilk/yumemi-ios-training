//
//  RequestModel.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/22.
//

import Foundation

struct WeatherRequest: Codable, Equatable {
    let area: String
    let date: Date
}

struct AreaWeatherRequest: Codable, Equatable {
    let areas: [String]
    let date: Date
}
