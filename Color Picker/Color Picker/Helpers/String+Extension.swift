//
//  String+Extension.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

extension String {
    var isValidateHex: Bool {
        let allPossible = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        
        for char in self {
            if !allPossible.contains(String(char).lowercased()) {
                return false
            }
        }
        
        return true
    }
    
    func getColors() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if isValidateHex {
            let scanner = Scanner(string: self)
            var hexNumber: UInt32 = 0

            if scanner.scanHexInt32(&hexNumber) {
                return hexNumber.colors
            }
        }
        
        return (0, 0, 0)
    }
    
    func remove(char: String.Element) -> String {
        var temp = ""
        
        for val in self {
            if val != char {
                temp += String(val)
            }
        }
        
        return temp
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}
