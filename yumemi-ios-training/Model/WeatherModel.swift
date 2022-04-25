//
//  WeatherModel.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/19.
//

import Combine
import Foundation

protocol WeatherModel {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func requestWeather(area: String, date: Date) async throws -> Weather
}
