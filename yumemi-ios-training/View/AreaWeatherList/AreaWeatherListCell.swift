//
//  AreaWeatherListCell.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/22.
//

import Foundation
import UIKit
import SnapKit

final class AreaWeatherListCell: UITableViewCell {
    
    static let identifier = "AreaWeatherListCell"
    
    let iconView = WeatherIconView()
    let areaLabel = UILabel()
    let minTemperatureLabel = UILabel()
    let maxTemperatureLabel = UILabel()
    
    let iconLength: CGFloat = 40
    let temperatureLabelMinWidth: CGFloat = 36
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviewsAndConstraints()
        setViewsProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = .init(top: 0, left: areaLabel.frame.origin.x, bottom: 0, right: 0)
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView.readableContentGuide)
            make.size.equalTo(iconLength)
            make.bottom.lessThanOrEqualTo(contentView.readableContentGuide)
        }
        
        contentView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(16)
            make.top.equalTo(contentView.readableContentGuide)
            make.trailing.lessThanOrEqualTo(contentView.readableContentGuide)
        }
        
        contentView.addSubview(minTemperatureLabel)
        minTemperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(areaLabel)
            make.top.equalTo(areaLabel.snp.bottom).offset(8)
            make.width.greaterThanOrEqualTo(temperatureLabelMinWidth)
            make.bottom.lessThanOrEqualTo(contentView.readableContentGuide)
        }
        
        contentView.addSubview(maxTemperatureLabel)
        maxTemperatureLabel.snp.makeConstraints { make in
            make.leading.equalTo(minTemperatureLabel.snp.trailing).offset(8)
            make.top.equalTo(minTemperatureLabel)
            make.width.greaterThanOrEqualTo(temperatureLabelMinWidth)
            make.trailing.lessThanOrEqualTo(contentView.readableContentGuide)
        }
    }
    
    private func setViewsProperties() {
        iconView.contentMode = .scaleAspectFit
        areaLabel.font = .preferredFont(forTextStyle: .headline)
        minTemperatureLabel.textColor = .systemBlue
        maxTemperatureLabel.textColor = .systemRed
        
        self.accessoryType = .disclosureIndicator
    }
    
    func configure(areaWeather: AreaWeather) {
        iconView.setIcon(with: areaWeather.info.name)
        areaLabel.text = areaWeather.area.rawValue
        minTemperatureLabel.text = String(areaWeather.info.minTemperature)
        maxTemperatureLabel.text = String(areaWeather.info.maxTemperature)
    }
}
