//
//  EmptyViewController.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/18.
//

import UIKit

final class EmptyViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let weatherViewController = WeatherViewController(weatherModel: WeatherClient())
        weatherViewController.modalPresentationStyle = .fullScreen
        present(weatherViewController, animated: true, completion: nil)
    }
}
