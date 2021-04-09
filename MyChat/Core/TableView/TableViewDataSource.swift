//
//  TableViewDataSource.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit
import Firebase
import CoreData

// MARK: - TableViewDataSource

class TableViewDataSource<Model: NSFetchRequestResult>: NSObject, UITableViewDataSource {
    
    // MARK: - Private properties
    
    private let database: Firestore
    
    private let coreDataStack: CoreDataStack?
    
    private let fetchedResultsController: NSFetchedResultsController<Model>?
    
    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - Initialization
    
    init(database: Firestore,
         coreDataStack: CoreDataStack?,
         fetchedResultsController: NSFetchedResultsController<Model>) {
        self.database = database
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
    }
    
    // MARK: - Public methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let object = fetchedResultsController?.object(at: indexPath)
        else { return UITableViewCell() }
        
        if let channel = object as? Channel {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationsListCell",
                                                           for: indexPath) as? ConversationsListCell
            else { return UITableViewCell() }
            cell.configure(with: channel)
            return cell
        } else if let message = object as? Message {
            
            let inbox = message.senderId != deviceID
            let cellIdentifier = inbox ? "ConversationInboxCell" : "ConversationOutboxCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                           for: indexPath) as? ConversationCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: message, inbox: inbox)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let object = fetchedResultsController?.object(at: indexPath)
        
        if editingStyle == .delete {
            
            if let channel = object as? Channel,
               let identifier = channel.identifier {
                database.collection("channels").document(identifier).delete()
            } else if let message = object as? Message,
                      let channelIdentifier = message.channel?.identifier,
                      let messageIdentifier = message.identifier {
                database.collection("channels").document(channelIdentifier).collection("messages").document(messageIdentifier).delete()
            }
        }
    }
}
