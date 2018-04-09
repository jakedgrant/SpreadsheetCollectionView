//
//  CustomCollectionViewCell.swift
//  TwoDimensionalCollectionView
//
//  Created by Jake Grant on 4/7/18.
//  Copyright © 2018 Jake Grant. All rights reserved.
//

import UIKit

@IBDesignable
class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 0.0
    }
}
