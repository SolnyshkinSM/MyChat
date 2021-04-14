//
//  CoreDataStackProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
}
