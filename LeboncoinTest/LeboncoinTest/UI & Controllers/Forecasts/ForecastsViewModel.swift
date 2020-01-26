//
//  ForecastsViewModel.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ForecastsViewModel {
    
    let manager = ForecastsManager()
    
    var dataRefresh = PublishRelay<Void>()
    var uiRefresh = PublishRelay<Void>()
    var bag: DisposeBag! = DisposeBag()
    
    init() {
        //Cette séquence représente la transformation de la demande de refresh de données par le bouton de l'interface en signal représentant l'ordre de refresh UI poussé au controlleur. Lors du tap, on télécharge les données via le manager, qui les enregistre dans sa variable membre "currentForecasts" ainsi que dans le stockage du tel, puis on renvoie l'ordre de mise à jour graphique à l'interface
        dataRefresh
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)//Delay avant le traitement, anti-spam, optionnel
            .flatMap(manager.rx.forecasts)
            .retry(3)
            .map({ _ in })
            .bind(to: uiRefresh)
            .disposed(by: bag)
        
        //Cette sequence représente le premier téléchargement des données, seulement si il n'y a pas de sauvegarde locale (donc première utilisation)
        manager.rx.forecasts()
            .retry(3)
            .map({ _ in })
            .bind(to: uiRefresh)
            .disposed(by: bag)
    }
    
    private var _forecastsByDay: [[Forecast]]!
    var forecastsByDay: [[Forecast]] {
        if let array = _forecastsByDay, !array.isEmpty {
            return array
        }
        //On regroupe les prévisions rangées par date en tableau de prévisions filtré par jour
        //Permet de faire des groupement par jour et d'avoir autant de sections de que de jours
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MM/dd"
        _forecastsByDay = Dictionary(grouping: manager.currentForecasts.values, by: { (elt) -> String in
            monthDayFormatter.string(from: elt.date ?? Date()).capitalized
        })
        .sorted(by: { (kv1, kv2) -> Bool in
            kv1.key < kv2.key
        })
        .map({ $0.value })

        return _forecastsByDay
    }
    
    var firstForecast: Forecast? {
        return forecastsByDay.first?.first
    }
    
    var cityText: String {
        return manager.currentCity
    }
    
    var tempText: String {
        return "\(cityText)\n\(firstForecast?.temperature.main ?? 0.0)°"
    }

    var windText: String {
        return "\(firstForecast?.wind._10m ?? 0) m/s"
    }

    var cloudsText: String {
        return "\(firstForecast?.clouds.total ?? 0) %"
    }

    var humidityText: String {
        return "\(firstForecast?.humidity._2m ?? 0) %"
    }

    var pressureText: String {
        return "\(Int(firstForecast?.pressure.seaLvl ?? 0) ) hpa"
    }

    func currentForecastIcon() -> UIImage? {
        forecastIcon(forecast: firstForecast)
    }
    
    func forecastIcon(forecast: Forecast?) -> UIImage? {
        let dayOrNight: () -> UIImage? = {
            let hour = Calendar.current.component(.hour, from: Date())
            if hour > 6 && hour < 18 {
                return UIImage(named: "day")
            }
            return UIImage(named: "night")
        }
        
        if let forecast = forecast {
            if forecast.snow {
                return UIImage(named: "snow")
            } else if forecast.rain {
                return UIImage(named: "rain")
            } else if forecast.clouds.total > 10 { //Disons que moins de 10% de nuages, c'est quand même un beau temps
                return UIImage(named: "cloud")
            } else {
                return dayOrNight()
            }
        }
        
        return dayOrNight()
    }
    
    func collectionViewCellText(pattern: NSAttributedString, indexPath: IndexPath) -> (UIImage?, NSAttributedString) {
        //Ici je suis confiant sur l'indexation sans vérification pour la simple et bonne raison que l'ensemble du rafraichissement est synchronisé grace à Rx. Etant donné que le refresh intervient séquentiellement après la récupération de data, on est bon
        let forecast = forecastsByDay[indexPath.section][indexPath.row]
        let copy = pattern.mutableCopy() as! NSMutableAttributedString
        let mutableString = copy.mutableString
        let date = forecast.date ?? Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E dd"
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        let day = dayFormatter.string(from: date).capitalized
        let hour = hourFormatter.string(from: date)
        let temp = "\(forecast.temperature.main)"
        mutableString.replaceOccurrences(of: "{day}", with: day, options: .backwards, range: mutableString.range(of: "{day}"))
        mutableString.replaceOccurrences(of: "{hour}", with: hour, options: .backwards, range: mutableString.range(of: "{hour}"))
        mutableString.replaceOccurrences(of: "{temp}", with: "\(temp)", options: .backwards, range: mutableString.range(of: "{temp}"))
        return (forecastIcon(forecast: forecast), copy)
    }
}
