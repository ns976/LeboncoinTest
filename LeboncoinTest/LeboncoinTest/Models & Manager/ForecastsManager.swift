//
//  ForecastsManager.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation
import RxSwift

class ForecastsManager {
    
    let network = DefaultNetworkService()
    let storage = DefaultStorageService()
    let location = DefaultLocationService()
    
    var currentForecasts = [Date: Forecast]()
    var currentCity = "-"
    
    init() {
        load()
    }
    
    private func save(_ city: String, _ forecasts: [Date: Forecast]) {
        currentForecasts = forecasts
        currentCity = city
        storage.save(encodable: currentForecasts, key: "forecasts")
        storage.save(encodable: currentCity, key: "city")
    }
    
    private func load() {
        currentForecasts = storage.load(key: "forecasts") ?? [:]
        currentCity = storage.load(key: "city") ?? ""
    }
    
    //Récupère la ville corresponsant à la localisation de l'utilisateur ainsi que les prévisions de celle-ci
    func forecasts(completion: @escaping ([Date: Forecast]) -> Void) {
        location.location { [unowned self] (location) in
            if let location = location {
                let endpoint = "http://www.infoclimat.fr/public-api/gfs/json?_ll=\(location.latitude),\(location.longitude)&_auth=CBJXQAR6ByVTfldgD3kELVA4VWAOeAYhA38GZQ9qXiMDaFAxUTFUMgRqAXwHKAYwBCkCYQ02BjYAawV9XS9UNQhiVzsEbwdgUzxXMg8gBC9QflU0Di4GIQNoBmkPfF48A2lQNFEsVDMEdQFiBzUGOgQoAn0NMwY7AGQFa105VDEIblc1BG4HZ1MjVyoPOgRlUGFVZg40Bm0DNgYyDzFeOQNnUGFRZ1Q3BHUBYQcwBjQEMgJlDTAGOABiBX1dL1ROCBhXLgQnBydTaVdzDyIEZVA9VWE%3D&_c=bd054cd89eade27ee5fcf2be14e8fc73"
                self.network.get(ForecastResponse.self, route: endpoint) { (result) in
                    switch result {
                    case .success(let response):
                        self.save(location.city, response.forecasts)
                        completion(response.forecasts)
                    case .failure:
                        completion([:])
                    }
                }
            } else {
                completion([:])
            }
        }
    }
}

extension ForecastsManager: ReactiveCompatible {}
extension Reactive where Base: ForecastsManager {
    func forecasts() -> Observable<[Date: Forecast]> {
        return Observable.deferred { () -> Observable<[Date: Forecast]> in
            return Observable.create { (observer) -> Disposable in
                self.base.forecasts { (result) in
                    if result.isEmpty {
                        observer.onError(NetworkError.noData(url: "/forecasts"))
                    } else {
                        observer.onNext(result)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
    }
}
