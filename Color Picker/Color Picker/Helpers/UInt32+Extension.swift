//
//  UInt32+Extension.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

extension UInt32 {
    var hex: String {
        String(self, radix: 16, uppercase: true)
    }
    
    var colors: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let red = (self & 0xFF0000) >> 16
        let green = (self & 0x00FF00) >> 8
        let blue = (self & 0x0000FF)
        
        return (CGFloat(red), CGFloat(green), CGFloat(blue))
    }
}
