//
//  Int+Extensions.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 26/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import Foundation

extension Double {
    var celsius: Double {
        return self - 273.5
    }
    
    var rounded: Double {
        let divisor = pow(10.0, Double(2))
        return (self * divisor).rounded() / divisor
    }
}
