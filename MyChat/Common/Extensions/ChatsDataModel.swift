//
//  ChatsDataModel.swift
//  MyChat
//
//  Created by Administrator on 27.03.2021.
//

import Foundation
import CoreData

// MARK: - Channel_db

extension Channel_db {
    
    convenience init(channel: Channel,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    var about: String {
        let description = "\(String(describing: name)), identifier: \(String(describing: identifier)) \n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? Message_db }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}

// MARK: - Message_db

extension Message_db {
    
    convenience init(message: Message,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
    
    var about: String {
        return "message: \(String(describing: content)), created: \(String(describing: created))"
    }
}
