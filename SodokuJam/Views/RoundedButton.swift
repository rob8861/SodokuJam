//
//  MainMenuView.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import SnapKit

class RoundedButton : UIButton
{
    var label: String!
    var color: UIColor!

    init(label: String, color: UIColor) {
        super.init(frame: .zero)
        self.label = label
        self.color = color
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout()
    {
        backgroundColor = color
        layer.cornerRadius = 25
        
        let title = UILabel()
        title.text = label
        title.textColor = UIColor.white
        title.font = UIFont(name: "AvenirNext-Bold", size: 20)
        
        self.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
            
        }
    }
}
