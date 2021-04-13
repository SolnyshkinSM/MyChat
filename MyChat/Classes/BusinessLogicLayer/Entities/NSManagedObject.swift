//
//  NSManagedObject.swift
//  MyChat
//
//  Created by Administrator on 04.04.2021.
//

import Foundation
import CoreData

// MARK: - NSManagedObject

public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
