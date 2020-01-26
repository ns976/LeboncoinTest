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
    @IBOutlet weak var collectionView:      UICollectionView!
    
    let viewModel = ForecastsViewModel()
    var selected: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Forecasts"
        
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
        tempValueLabel.text = viewModel.localAndTempText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? ForecastDetailViewController, let forecast = selected {
            detail.viewModel = ForecastDetailViewModel(forecast: forecast, manager: viewModel.manager)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = viewModel.forecast(at: indexPath)
        performSegue(withIdentifier: "forecastsToDetail", sender: self)
    }
}
