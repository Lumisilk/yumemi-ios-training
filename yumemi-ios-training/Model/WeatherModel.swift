//
//  WeatherModel+Impl.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/19.
//

import Foundation
import Combine

protocol WeatherModel {
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func fetchWeather(area: String, date: Date) -> AnyPublisher<Weather, Error>
}
