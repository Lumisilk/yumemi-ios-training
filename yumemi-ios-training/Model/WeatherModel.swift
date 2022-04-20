//
//  WeatherModel.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/19.
//

import Foundation

protocol WeatherModel {
    func requestWeather(area: String, date: Date, completion: @escaping (Result<Weather, Error>) -> Void)
}
