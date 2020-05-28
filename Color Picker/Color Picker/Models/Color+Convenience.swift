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
    
    static func == (lhs: Color, rhs: ColorRepresentation) -> Bool {
        return lhs.name == rhs.name && UInt32(lhs.hex) == rhs.hex
    }
}
