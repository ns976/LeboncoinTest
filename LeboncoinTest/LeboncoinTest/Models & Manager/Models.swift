//
//  Models.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation

struct Location: Codable {
    let city: String
    let latitude: Double
    let longitude: Double
}

struct DynamicKey: CodingKey {
    var intValue: Int?
    
    init?(intValue: Int) {
        return nil
    }
    
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
}

struct ForecastResponse: Codable {
    let request_state: Int
    let message: String
    var forecasts: [Date: Forecast]
    
    enum CodingKeys: String, CodingKey {
        case request_state, message, forecasts
    }
    
    init(from decoder: Decoder) throws {
        let dynamicKeysContainer = try decoder.container(keyedBy: DynamicKey.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.request_state = try container.decode(Int.self, forKey: .request_state)
        self.message = try container.decode(String.self, forKey: .message)
        
        do {
            //Decoding à partir de la sauvegarde locale (une sérialisation du modèle)
            self.forecasts = try container.decode([Date: Forecast].self, forKey: .forecasts)
        } catch {
            //Decoding à partir de la structure de resultat du webservice
            var forecasts = [Date: Forecast]()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            try dynamicKeysContainer.allKeys.forEach { key in
                if key.stringValue.range(of: #"(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)\w+"#, options: .regularExpression) != nil {
                    if let date = formatter.date(from: key.stringValue) {
                        let forecast = try dynamicKeysContainer.decode(Forecast.self, forKey: key)
                        forecasts[date] = forecast
                    }
                }
            }
            self.forecasts = forecasts
        }
    }
}

struct Forecast: Codable {
    let pressure: Pressure
    let temperature: Temperature
    let clouds: Clouds
    
    enum CodingKeys: String, CodingKey {
        case pressure = "pression"
        case temperature = "temperature"
        case clouds = "nebulosite"
    }
    
    struct Pressure: Codable {
        let seaLvl: Int
        
        enum CodingKeys: String, CodingKey {
            case seaLvl = "niveau_de_la_mer"
        }
    }
    
    struct Temperature: Codable {
        let main: Double
        let _2m: Double
        let _500hPa: Double
        let _850hPa: Double
        
        enum CodingKeys: String, CodingKey {
            case main = "sol"
            case _2m = "2m"
            case _500hPa = "500hPa"
            case _850hPa = "850hPa"
        }
    }
    
    struct Clouds: Codable {
        let total: Int
        
        enum CodingKeys: String, CodingKey {
            case total = "totale"
        }
    }
    
    struct Humidity: Codable {
        let _2m: Double
        
        enum CodingKeys: String, CodingKey {
            case _2m = "2m"
        }
    }
}
