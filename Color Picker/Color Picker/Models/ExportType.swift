//
//  ExportType.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/27/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

enum ExportType: String {
    case uicolor = "Swift UIColor"
    case hex = "CSS Hexadecimal"
    case nscolor = "Swift NSColor"
    case cgcolor = "Swift CGColor"
    case javargba = "Java RGBA"
    case netargb = ".NET ARGB"
    case openglrgba = "OpenGL RGBA"
}
