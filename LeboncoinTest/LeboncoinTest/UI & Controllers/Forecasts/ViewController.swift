//
//  ViewController.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let manager = ForecastsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.forecasts { (forecasts) in
            print(forecasts)
        }
    }
}

