//
//  Square.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import Foundation

/*
 This class represents a square on the sodoku board.
 It holds the value and the coordinates of the square
 */
class Square
{
    var value: String {
        get { return _value }
        set { _value = newValue }
    }
    
    var row: Int {
        return _row
    }
    
    var col: Int {
        return _col
    }
    
    init(value: String, row: Int, col: Int) {
        
        _value = value
        _row = row
        _col = col
    }
    
    private var _value: String!
    private var _row: Int!
    private var _col: Int!
}
