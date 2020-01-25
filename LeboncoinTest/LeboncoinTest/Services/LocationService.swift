//
//  LocationService.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationService {
    func location(completion: @escaping (Location?) -> Void)
}

typealias DefaultLocationService = CoreLocationService

class CoreLocationService: NSObject, LocationService {
    typealias Callback = (Location?) -> Void
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var callback: Callback?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func location(completion: @escaping (Location?) -> Void) {
        callback = completion
        manager.requestAlwaysAuthorization()
    }
}

extension CoreLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            geocoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
                if error != nil {
                    self.callback?(Location(city: "-",
                                            latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude))
                } else {
                    self.callback?(Location(city: placemarks?.map({ $0.locality ?? "-" }).first ?? "-",
                                       latitude: location.coordinate.latitude,
                                       longitude: location.coordinate.longitude))
                }
            }
        } else {
            callback?(nil)
        }
    }
}
