//
//  ForecastsManager.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation

class ForecastsManager {
    
    let network = DefaultNetworkService()
    let storage = DefaultStorageService()
    let location = DefaultLocationService()
    
    var savedForecasts = [Date: Forecast]()
    
    init() {
        load()
    }
    
    private func save(_ forecasts: [Date: Forecast]) {
        savedForecasts = forecasts
        storage.save(encodable: savedForecasts, key: "forecasts")
    }
    
    private func load() {
        savedForecasts = storage.load(key: "forecasts") ?? [:]
    }
    
    func forecasts(completion: @escaping ([Date: Forecast]) -> Void) {
        location.location { [unowned self] (location) in
            if let location = location {
                let endpoint = "http://www.infoclimat.fr/public-api/gfs/json?_ll=\(location.latitude),\(location.longitude)&_auth=CBJXQAR6ByVTfldgD3kELVA4VWAOeAYhA38GZQ9qXiMDaFAxUTFUMgRqAXwHKAYwBCkCYQ02BjYAawV9XS9UNQhiVzsEbwdgUzxXMg8gBC9QflU0Di4GIQNoBmkPfF48A2lQNFEsVDMEdQFiBzUGOgQoAn0NMwY7AGQFa105VDEIblc1BG4HZ1MjVyoPOgRlUGFVZg40Bm0DNgYyDzFeOQNnUGFRZ1Q3BHUBYQcwBjQEMgJlDTAGOABiBX1dL1ROCBhXLgQnBydTaVdzDyIEZVA9VWE%3D&_c=bd054cd89eade27ee5fcf2be14e8fc73"
                self.network.get(ForecastResponse.self, route: endpoint) { (result) in
                    switch result {
                    case .success(let response):
                        self.save(response.forecasts)
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
