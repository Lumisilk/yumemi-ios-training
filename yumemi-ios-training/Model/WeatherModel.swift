//
//  WeatherModel+Impl.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/19.
//

import Foundation

protocol WeatherModel {
    func fetchWeather(area: String, date: Date) -> Result<Weather, Error>
}
