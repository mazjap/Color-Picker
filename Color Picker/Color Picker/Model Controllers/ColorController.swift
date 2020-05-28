//
//  ColorController.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/27/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class ColorController {
    @discardableResult func add(name: String, hex: UInt32) -> Color {
        let color = Color(name: name, hex: hex)
        CoreDataStack.shared.saveToPersistentStore()
        return color
    }
    
    func update(color: Color, name: String, hex: UInt32) {
        color.name = name
        color.hex = Int64(hex)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    func delete(color: Color) {
        CoreDataStack.shared.mainContext.delete(color)
        CoreDataStack.shared.saveToPersistentStore()
    }
}
