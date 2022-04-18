//
//  ViewController.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/07.
//

import UIKit
import SnapKit
import YumemiWeather

class WeatherViewController: UIViewController {
    
    /// A LayoutGuide contains the imageView and two temperature labels.
    let infoContainerLayoutGuide = UILayoutGuide()
    let weatherIconView = WeatherIconView()
    let minTemperatureLabel = UILabel()
    let maxTemperatureLabel = UILabel()
    
    let closeButton = UIButton(type: .system)
    let reloadButton = UIButton(type: .system)
    
    let dateLabel = UILabel()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    var client = WeatherClient()
    
    override func viewDidLoad() {
        addSubviewsAndConstraints()
        setViewsProperties()
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(weatherIconView)
        weatherIconView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(weatherIconView.snp.width)
        }
        
        view.addSubview(minTemperatureLabel)
        minTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconView.snp.bottom)
            make.leading.equalTo(weatherIconView)
            make.width.equalTo(weatherIconView).dividedBy(2)
        }
        
        view.addSubview(maxTemperatureLabel)
        maxTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconView.snp.bottom)
            make.trailing.equalTo(weatherIconView)
            make.width.equalTo(weatherIconView).dividedBy(2)
        }
        
        view.addLayoutGuide(infoContainerLayoutGuide)
        infoContainerLayoutGuide.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(weatherIconView)
            make.bottom.equalTo(minTemperatureLabel)
            make.center.equalToSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(minTemperatureLabel.snp.bottom).offset(80)
            make.centerX.equalTo(minTemperatureLabel)
        }
        
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(maxTemperatureLabel.snp.bottom).offset(80)
            make.centerX.equalTo(maxTemperatureLabel)
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoContainerLayoutGuide.snp.top).offset(-40)
        }
    }
    
    private func setViewsProperties() {
        view.backgroundColor = .white
        
        minTemperatureLabel.text = "--"
        minTemperatureLabel.textColor = .systemBlue
        minTemperatureLabel.textAlignment = .center
        minTemperatureLabel.font = .preferredFont(forTextStyle: .title1)
        maxTemperatureLabel.text = "--"
        maxTemperatureLabel.textColor = .systemRed
        maxTemperatureLabel.textAlignment = .center
        maxTemperatureLabel.font = .preferredFont(forTextStyle: .title1)
        
        dateLabel.text = "--"
        dateLabel.textAlignment = .center
        
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        reloadButton.setTitle(NSLocalizedString("Reload", comment: ""), for: .normal)
        reloadButton.addAction(
            UIAction(handler: { [weak self] _ in self?.reloadWeather() }),
            for: .touchUpInside
        )
    }
    
    private func reloadWeather() {
        do {
            let weather = try client.fetchWeather(area: "Tokyo")
            showWeather(weather)
        } catch {
            presentError(error)
        }
    }
    
    private func showWeather(_ weather: Weather) {
        minTemperatureLabel.text = String(weather.minTemperature)
        maxTemperatureLabel.text = String(weather.maxTemperature)
        weatherIconView.setIcon(with: weather.name)
        dateLabel.text = dateFormatter.string(from: weather.date)
    }
    
    private func presentError(_ error: Error) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Oops!", comment: "The title for errors."),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: ""),
                style: .default,
                handler: nil
            )
        )
        present(alertController, animated: true, completion: nil)
    }
}
