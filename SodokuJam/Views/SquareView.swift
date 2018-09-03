//
//  SquareView.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/15/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import SnapKit

class SquareView: UIView
{
    enum SquareColor {
        case white
        case gray
    }
    
    var square: Square!
    var lbl: UILabel!
    
    init(frame: CGRect, square: Square) {
        super.init(frame: frame)
        self.square = square
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLabel(number: String)
    {
        lbl.text = number
    }
    
    func updateSqaureViewColor(_ color: SquareColor)
    {
        switch color {
        case .white:
            layer.backgroundColor = UIColor.white.cgColor
        case .gray:
            layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
    
    private func setLayout()
    {
        layer.backgroundColor = UIColor.white.cgColor
        layer.opacity = 0.7
        
        lbl = UILabel()
        lbl.text = square.value
        lbl.textColor = UIColor.black
        lbl.sizeToFit()

        self.addSubview(lbl)
        
        lbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)

        }
    }
    
}
