//
//  ForecastDetailViewController.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {

    @IBOutlet weak var globalWeatherImage:  UIImageView!
    @IBOutlet weak var tempValueLabel:          UILabel!
    @IBOutlet weak var windValueLabel:          UILabel!
    @IBOutlet weak var cloudsValueLabel:        UILabel!
    @IBOutlet weak var humidityValueLabel:      UILabel!
    @IBOutlet weak var pressureValueLabel:      UILabel!
    
    var viewModel: ForecastDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Forecast"
        
        globalWeatherImage.image = viewModel.currentForecastIcon()
        tempValueLabel.text = viewModel.localAndTempText
        windValueLabel.text = viewModel.windText
        cloudsValueLabel.text = viewModel.cloudsText
        humidityValueLabel.text = viewModel.humidityText
        pressureValueLabel.text = viewModel.pressureText
    }

}
