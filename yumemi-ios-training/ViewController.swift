//
//  ViewController.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/07.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {
    
    /// A LayoutGuide containing the imageView and two labels.
    let infoContainerLayoutGuide = UILayoutGuide()
    let imageView = UIImageView()
    let blueLabel = UILabel()
    let redLabel = UILabel()
    
    let closeButton = UIButton(type: .system)
    let reloadButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(imageView.snp.width)
        }
        
        view.addSubview(blueLabel)
        blueLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(imageView)
            make.width.equalTo(imageView).dividedBy(2)
        }
        
        view.addSubview(redLabel)
        redLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.trailing.equalTo(imageView)
            make.width.equalTo(imageView).dividedBy(2)
        }
        
        view.addLayoutGuide(infoContainerLayoutGuide)
        infoContainerLayoutGuide.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(imageView)
            make.bottom.equalTo(blueLabel)
            make.center.equalToSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(blueLabel.snp.bottom).offset(80)
            make.centerX.equalTo(blueLabel)
        }
        
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(redLabel.snp.bottom).offset(80)
            make.centerX.equalTo(redLabel)
        }
        
        blueLabel.text = "--"
        blueLabel.textColor = .systemBlue
        blueLabel.textAlignment = .center
        redLabel.text = "--"
        redLabel.textColor = .systemRed
        redLabel.textAlignment = .center
        
        closeButton.setTitle("Close", for: .normal)
        reloadButton.setTitle("Reload", for: .normal)
    }
}
