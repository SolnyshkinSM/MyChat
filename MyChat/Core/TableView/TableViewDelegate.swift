//
//  TableViewDelegate.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import Foundation
import Firebase
import CoreData

// MARK: - TableViewDelegate

class TableViewDelegate<Model: NSFetchRequestResult>: NSObject, UITableViewDelegate {
    
    // MARK: - Private properties
    
    private let coordinator: IChannelsCoordinator?
    
    private let coreDataStack: CoreDataStack?
    
    private let listener: ListenerRegistration?
    
    private let fetchedResultsController: NSFetchedResultsController<Model>?
    
    // MARK: - Initialization
    
    init(coordinator: IChannelsCoordinator?,
         coreDataStack: CoreDataStack?,
         listener: ListenerRegistration?,
         fetchedResultsController: NSFetchedResultsController<Model>) {
        self.coordinator = coordinator
        self.coreDataStack = coreDataStack
        self.listener = listener
        self.fetchedResultsController = fetchedResultsController
    }
    
    // MARK: - Public methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let object = fetchedResultsController?.object(at: indexPath),
           let coreDataStack = coreDataStack,
           let channel = object as? Channel {
            coordinator?.goToChannelDetailViewController(coreDataStack: coreDataStack, channel: channel)
            listener?.remove()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard Model.self == Message.self else { return }
        guard let countFetchedObjects = fetchedResultsController?.fetchedObjects?.count
        else { return }
        
        if indexPath.row == countFetchedObjects - 1 {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.bounds.size.height)
            UIView.animate(withDuration: 0.7, delay: 0.05,
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: [], animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
                           }, completion: nil)
        }
    }
}
