//
//  FetchedResultsControllerProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import Foundation
import CoreData

// MARK: - FetchedResultsControllerProtocol

protocol FetchedResultsControllerProtocol: NSObject, NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    func scrollToRowFetchedObjects(controller: NSFetchedResultsController<NSFetchRequestResult>)
}
