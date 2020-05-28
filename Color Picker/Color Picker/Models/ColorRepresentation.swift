//
//  ColorRepresentation.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/27/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

struct ColorRepresentation: Codable {
    var name: String
    var hex: UInt32
    var id: UUID
    
    init?(color: Color) {
        guard let name = color.name, let uuid = color.id else { return nil }
        self.init(name: name, hex: UInt32(color.hex), uuid: uuid)
    }
    
    init(name: String, hex: UInt32, uuid: UUID) {
        self.name = name
        self.hex = hex
        self.id = uuid
    }
    
    static func == (lhs: ColorRepresentation, rhs: Color) -> Bool {
        return lhs.name == rhs.name && lhs.hex == UInt32(rhs.hex)
    }
}
