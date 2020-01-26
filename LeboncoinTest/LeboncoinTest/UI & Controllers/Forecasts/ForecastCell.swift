//
//  ForecastCell.swift
//  LeboncoinTest
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherText: UILabel!
    static var pattern: NSAttributedString!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if ForecastCell.pattern == nil {
           ForecastCell.pattern = weatherText.attributedText
        }
    }
}
