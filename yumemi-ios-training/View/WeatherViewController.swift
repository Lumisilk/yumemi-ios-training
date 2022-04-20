//
//  ViewController.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/07.
//

import UIKit
import SnapKit

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
    
    let activityView = UIActivityIndicatorView()
    
    private var weatherModel: WeatherModel
    
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addSubviewsAndConstraints()
        setViewsProperties()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadWeather),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
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
        
        view.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoContainerLayoutGuide.snp.bottom)
            make.bottom.equalTo(closeButton.snp.top)
        }
    }
    
    private func setViewsProperties() {
        view.backgroundColor = .systemBackground
        
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
        closeButton.addAction(
            UIAction(handler: { [weak self] _ in self?.dismiss(animated: true, completion: nil) }),
            for: .touchUpInside
        )
        reloadButton.setTitle(NSLocalizedString("Reload", comment: ""), for: .normal)
        reloadButton.addAction(
            UIAction(handler: { [weak self] _ in self?.reloadWeather() }),
            for: .touchUpInside
        )
    }
    
    @objc func reloadWeather() {
        setLoadingState(isLoading: true)
        weatherModel.requestWeather(area: "Tokyo", date: Date()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.presentError(error, showErrorDetail: false)
                case .success(let weather):
                    self?.showWeather(weather)
                }
                self?.setLoadingState(isLoading: false)
            }
        }
    }
    
    private func setLoadingState(isLoading: Bool) {
        if isLoading {
            activityView.startAnimating()
            reloadButton.isEnabled = false
        } else {
            activityView.stopAnimating()
            reloadButton.isEnabled = true
        }
    }
    
    private func showWeather(_ weather: Weather) {
        minTemperatureLabel.text = String(weather.minTemperature)
        maxTemperatureLabel.text = String(weather.maxTemperature)
        weatherIconView.setIcon(with: weather.name)
        dateLabel.text = dateFormatter.string(from: weather.date)
    }
    
    private func presentError(_ error: Error, showErrorDetail: Bool) {
        let errorMessage = showErrorDetail ? error.localizedDescription: NSLocalizedString("An error occurred.", comment: "")
        let alertController = UIAlertController(
            title: NSLocalizedString("Oops!", comment: "The title for errors."),
            message: errorMessage,
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
