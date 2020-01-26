//
//  ForecastsViewController.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import UIKit
import RxSwift

class ForecastsViewController: UIViewController {

    @IBOutlet weak var refreshButton:       UIButton!
    @IBOutlet weak var globalWeatherImage:  UIImageView!
    @IBOutlet weak var tempValueLabel:      UILabel!
    @IBOutlet weak var windValueLabel:      UILabel!
    @IBOutlet weak var cloudsValueLabel:    UILabel!
    @IBOutlet weak var humidityValueLabel:  UILabel!
    @IBOutlet weak var pressureValueLabel:  UILabel!
    @IBOutlet weak var collectionView:      UICollectionView!
    
    let viewModel = ForecastsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.rx.tap
            .bind(to: viewModel.dataRefresh)
            .disposed(by: viewModel.bag)
        
        viewModel.uiRefresh
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] _ in
                self.uiRefresh()
            }
            .disposed(by: viewModel.bag)
        
        uiRefresh()
    }
    
    func uiRefresh() {
        collectionView.reloadData()
        globalWeatherImage.image = viewModel.currentForecastIcon()
        tempValueLabel.text = viewModel.tempText
        windValueLabel.text = viewModel.windText
        cloudsValueLabel.text = viewModel.cloudsText
        humidityValueLabel.text = viewModel.humidityText
        pressureValueLabel.text = viewModel.pressureText
    }
}

extension ForecastsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCell {
            let uiItems = viewModel.collectionViewCellText(pattern: ForecastCell.pattern, indexPath: indexPath)
            cell.weatherIcon.image = uiItems.0
            cell.weatherText.attributedText = uiItems.1
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.forecastsByDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastsByDay[section].count
    }
}
