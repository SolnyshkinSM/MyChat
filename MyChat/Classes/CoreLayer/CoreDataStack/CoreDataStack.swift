//
//  CoreDataStack.swift
//  MyChat
//
//  Created by Administrator on 27.03.2021.
//

import Foundation
import CoreData

// MARK: - CoreDataStack

class CoreDataStack: CoreDataStackProtocol {
        
    // MARK: - Private properties
    
    private let dataBaseName: String
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Public properties
    
    lazy var context: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Initialization
    
    init(dataBaseName: String) {
        self.dataBaseName = dataBaseName
    }
    
    // MARK: - Public methods
    
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
