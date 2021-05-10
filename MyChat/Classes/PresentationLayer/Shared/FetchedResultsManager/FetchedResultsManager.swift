//
//  FetchedResultsManager.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit
import CoreData

// MARK: - FetchedResultsManager

class FetchedResultsManager<Model: NSFetchRequestResult> {

    // MARK: - Private properties

    private let tableView: UITableView

    private let sortDescriptors: [NSSortDescriptor]

    private let coreDataStack: CoreDataStackProtocol?

    private let fetchRequest: NSFetchRequest<Model>

    private let predicate: NSPredicate?

    private var tempFetchedResultsController: NSFetchedResultsController<Model>?

    // MARK: - Public properties

    var fetchedResultsControllerDelegate: FetchedResultsControllerProtocol?

    var fetchedResultsController: NSFetchedResultsController<Model> {

        if let tempFetchedResultsController = tempFetchedResultsController {
            return tempFetchedResultsController
        }

        guard let context = coreDataStack?.context else { return NSFetchedResultsController<Model>() }

        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 10
        fetchRequest.sortDescriptors = sortDescriptors

        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        aFetchedResultsController.delegate = fetchedResultsControllerDelegate
        tempFetchedResultsController = aFetchedResultsController

        do {
            try tempFetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return tempFetchedResultsController ?? NSFetchedResultsController<Model>()
    }

    // MARK: - Initialization

    init(tableView: UITableView,
         sortDescriptors: [NSSortDescriptor],
         fetchRequest: NSFetchRequest<Model>,
         predicate: NSPredicate? = nil,
         coreDataStack: CoreDataStackProtocol?) {
        self.tableView = tableView
        self.sortDescriptors = sortDescriptors
        self.fetchRequest = fetchRequest
        self.coreDataStack = coreDataStack
        self.predicate = predicate

        fetchedResultsControllerDelegate = FetchedResultsControllerDelegate<Model>(tableView: tableView)
    }
}
