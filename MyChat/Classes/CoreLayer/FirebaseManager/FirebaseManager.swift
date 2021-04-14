//
//  FirebaseManager.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import Foundation
import Firebase
import CoreData

// MARK: - FirebaseManager

class FirebaseManager<Model: NSFetchRequestResult>: FirebaseManagerProtocol {
    
    // MARK: - Private properties
    
    private let coreDataStack: CoreDataStackProtocol?
    
    private let reference: CollectionReference?
    
    private let fetchRequest: NSFetchRequest<Model>
    
    private let channel: Channel?
    
    // MARK: - Initialization
    
    init(coreDataStack: CoreDataStackProtocol?,
         reference: CollectionReference?,
         fetchRequest: NSFetchRequest<Model>,
         channel: Channel? = nil) {
        self.coreDataStack = coreDataStack
        self.reference = reference
        self.fetchRequest = fetchRequest
        self.channel = channel
    }
    
    // MARK: - Public methods
    
    func addSnapshotListener() -> ListenerRegistration? {
       
        guard let context = coreDataStack?.context else { return nil }

        fetchRequest.resultType = .managedObjectResultType

        let listener = reference?.addSnapshotListener { [weak self] snapshot, _ in

            snapshot?.documentChanges.forEach { diff in

                guard let fetchRequest = self?.fetchRequest else { return }

                let document = diff.document
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", document.documentID)
                guard let fetchResults = try? context.fetch(fetchRequest) else { return }

                if fetchResults.isEmpty {
                    self?.addNewObject(document, in: context)
                } else {

                    guard let object = fetchResults.first as? NSManagedObject else { return }

                    switch diff.type {
                    case .modified:

                        if let channel = object as? Channel,
                           channel.lastMessage != document.data()["lastMessage"] as? String {
                            self?.addNewObject(document, in: context)
                        }

                        if let message = object as? Message,
                           message.content != document.data()["content"] as? String {
                            self?.addNewObject(document, in: context)
                        }

                    case .removed:
                        context.delete(object)
                    default:
                        break
                    }
                }
            }
            self?.coreDataStack?.saveContext()
        }
        return listener
    }
    
    // MARK: - Private methods
    
    private func addNewObject(_ document: QueryDocumentSnapshot, in context: NSManagedObjectContext) {
        
        if Model.self == Channel.self {
            addNewChannel(document, in: context)
        } else if Model.self == Message.self {
            addNewMessage(document, in: context)
        }
    }
    
    private func addNewChannel(_ document: QueryDocumentSnapshot, in context: NSManagedObjectContext) {
        _ = Channel(identifier: document.documentID, with: document.data(), in: context)
    }
    
    private func addNewMessage(_ document: QueryDocumentSnapshot, in context: NSManagedObjectContext) {
        let message_db = Message(identifier: document.documentID,
                                 with: document.data(), in: context)
        channel?.addToMessages(message_db)
    }
}
