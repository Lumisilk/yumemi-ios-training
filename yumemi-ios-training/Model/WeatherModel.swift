//
//  WeatherModel.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/19.
//

import Combine
import Foundation

protocol WeatherModelDelegate: AnyObject {
    func didReceiveWeather(result: Result<Weather, Error>)
}

protocol WeatherModel {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var delegate: WeatherModelDelegate? { get set }
    func requestWeather(area: String, date: Date)
}
