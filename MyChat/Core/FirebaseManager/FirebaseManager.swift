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

class FirebaseManager {
    
    // MARK: - Private properties
    
    private let coreDataStack: CoreDataStack?
    
    private let reference: CollectionReference?
    
    // MARK: - Initialization
    
    init(coreDataStack: CoreDataStack?,
         reference: CollectionReference?) {
        self.coreDataStack = coreDataStack
        self.reference = reference
    }
    
    // MARK: - Public methods
    
    func addSnapshotListenerChannel() -> ListenerRegistration? {
        
        guard let context = coreDataStack?.context else { return nil }    
        
        let fetchRequest: NSFetchRequest<Channel> = Channel.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        
        let listener = reference?.addSnapshotListener { [weak self] snapshot, _ in
            
            snapshot?.documentChanges.forEach { diff in
                
                let document = diff.document
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", document.documentID)
                guard let fetchResults = try? context.fetch(fetchRequest) else { return }
                
                if fetchResults.isEmpty {
                    _ = Channel(identifier: document.documentID, with: document.data(), in: context)
                } else {
                    guard let channel = fetchResults.first else { return }
                    
                    switch diff.type {
                    case .modified:
                        let data = document.data()
                        if channel.lastMessage != data["lastMessage"] as? String {
                            _ = Channel(identifier: document.documentID, with: data, in: context)
                        }
                    case .removed:
                        context.delete(channel)
                    default:
                        break
                    }
                }
            }
            self?.coreDataStack?.saveContext()
        }
        
        return listener
    }
    
    func addSnapshotListenerMessage(for channel: Channel?) -> ListenerRegistration? {
        
        guard let context = coreDataStack?.context else { return nil }
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.resultType = .managedObjectResultType
        
        let listener = reference?.addSnapshotListener { [weak self] snapshot, _ in
            
            snapshot?.documentChanges.forEach { diff in
                
                let document = diff.document
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", document.documentID)
                guard let fetchResults = try? context.fetch(fetchRequest) else { return }
                
                if fetchResults.isEmpty {
                    let message_db = Message(identifier: document.documentID,
                                             with: document.data(), in: context)
                    channel?.addToMessages(message_db)
                } else {
                    guard let message = fetchResults.first else { return }
                    
                    switch diff.type {
                    case .modified:
                        let data = document.data()
                        if message.content != data["content"] as? String {
                            let message_db = Message(identifier: document.documentID,
                                                     with: document.data(), in: context)
                            channel?.addToMessages(message_db)
                        }
                    case .removed:
                        context.delete(message)
                    default:
                        break
                    }
                }
            }
            self?.coreDataStack?.saveContext()
        }
        
        return listener
    }
}
