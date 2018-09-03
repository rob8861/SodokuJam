//
//  SelectionButton.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/15/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit

class SelectionButton: UIButton
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
