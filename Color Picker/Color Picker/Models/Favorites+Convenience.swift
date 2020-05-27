//
//  Favorites+Convenience.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import CoreData

extension Favorites {
    convenience init(list: [Color], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.colors = NSOrderedSet(object: list)
    }
}
