//
//  DetailViewModel.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 26/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ForecastDetailViewModel {
    
    let forecast: Forecast
    let manager: ForecastsManager
    
    init(forecast: Forecast, manager: ForecastsManager) {
        self.forecast = forecast
        self.manager = manager
    }

    var localAndTempText: String {
        return "\(manager.currentCity)\n\(forecast.temperature.main.celsius.rounded)°"
    }
    
    var windText: String {
        return "\(forecast.wind._10m) km/h"
    }

    var cloudsText: String {
        return "\(forecast.clouds.total) %"
    }

    var humidityText: String {
        return "\(forecast.humidity._2m) %"
    }

    var pressureText: String {
        return "\(forecast.pressure.seaLvl / 100) hpa"
    }
    
    func currentForecastIcon() -> UIImage? {
        return forecast.picture()
    }
}
