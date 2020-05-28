//
//  CoreDataStack.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Color_Picker")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistant stores: \(error)")
            }
        })
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
}
