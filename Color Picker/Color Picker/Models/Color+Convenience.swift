//
//  Color+Convenience.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import CoreData

extension Color {
    convenience init(name: String, hex: UInt32, id: UUID? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.id = id ?? UUID()
        self.hex = Int64(hex)
    }
    
    var hexString: String {
        UInt32(hex).hex
    }
    
    var color: UIColor {
        UIColor(hexInt: UInt32(hex))
    }
    
    func share(type: ExportType) -> String {
        let colors = color.rgba
        
        switch type {
        case .hex:
            return "#\(hexString)"
        case .uicolor:
            return "UIColor(red: \(colors.red), green: \(colors.green), blue: \(colors.blue), alpha: \(colors.alpha)"
        case .nscolor:
            return "[NSColor colorWithRed:\(colors.red) green:\(colors.green) blue:0.\(colors.blue) alpha:\(colors.alpha)]"
        case .cgcolor:
            return "CGColorCreateGenericRGB(\(colors.red), \(colors.green), \(colors.blue), \(colors.alpha))"
        case .javargba:
            return "Color(\(colors.red * 255), \(colors.green * 255), \(colors.blue * 255), \(colors.alpha * 255))"
        case .netargb:
            return "Color.FromArgb(\(colors.alpha * 255), \(colors.red * 255), \(colors.green * 255), \(colors.blue * 255))"
        case .openglrgba:
            return "glColor4f(\(colors.red), \(colors.green), \(colors.blue), \(colors.alpha))"
        }
    }
    
    static func == (lhs: Color, rhs: ColorRepresentation) -> Bool {
        return lhs.name == rhs.name && UInt32(lhs.hex) == rhs.hex
    }
}
