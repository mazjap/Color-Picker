//
//  UIColor+Extension.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let colors = hex.getColors()
        self.init(red: colors.red / 255, green: colors.green / 255, blue: colors.blue / 255, alpha: 1.0)
    }
    
    convenience init(hexInt: UInt32) {
        let colors = hexInt.colors
        self.init(red: colors.red / 255, green: colors.green / 255, blue: colors.blue / 255, alpha: 1.0)
    }
    
    var textColor: UIColor {
        if rgba.red + rgba.green + rgba.blue > 555 { // 255 * 3 (r, g, b) - 210 (70 each) (if it's too bright, make text black)
            return UIColor.black
        }
        
        return UIColor.white
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red * 255, green * 255, blue * 255, alpha * 255)
    }
}
