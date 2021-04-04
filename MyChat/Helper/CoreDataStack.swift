//
//  CoreDataStack.swift
//  MyChat
//
//  Created by Administrator on 27.03.2021.
//

import UIKit
import CoreData

// MARK: - CoreDataStack

class CoreDataStack {
        
    private let dataBaseName = "Chats"
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
