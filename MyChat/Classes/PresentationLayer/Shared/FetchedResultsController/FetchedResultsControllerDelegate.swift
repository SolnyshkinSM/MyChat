//
//  FetchedResultsControllerDelegate.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit
import CoreData

// MARK: - FetchedResultsControllerDelegate

class FetchedResultsControllerDelegate<Model: NSFetchRequestResult>: NSObject, FetchedResultsControllerProtocol {

    // MARK: - Private properties

    private let tableView: UITableView

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    // MARK: - Public methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if tableView.window == nil { return }
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        if tableView.window == nil { return }
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if tableView.window == nil { return }
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationsListCell,
                  let channel = anObject as? Channel
            else { return }
            cell.configure(with: channel)
        case .move:
            guard let indexPath = indexPath,
                  let newIndexPath = newIndexPath,
                  let cell = tableView.cellForRow(at: indexPath) as? ConversationsListCell,
                  let channel = anObject as? Channel
            else { return }
            cell.configure(with: channel)
            tableView.moveRow(at: indexPath, to: newIndexPath)
        default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if tableView.window == nil { return }
        tableView.endUpdates()

        if Model.self == Message.self { scrollToRowFetchedObjects(controller: controller) }
    }

    func scrollToRowFetchedObjects(controller: NSFetchedResultsController<NSFetchRequestResult>) {

        if let countFetchedObjects = controller.fetchedObjects?.count,
           countFetchedObjects != 0 {
            let lastIndex = IndexPath(item: countFetchedObjects - 1, section: 0)
            tableView.scrollToRow(at: lastIndex,
                                  at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
