//
//  ChatsDataModel.swift
//  MyChat
//
//  Created by Administrator on 27.03.2021.
//

import Foundation
import CoreData
import Firebase

// MARK: - Channel

extension Channel {
    
    enum CodingKeys: String, CodingKey {
        case name
        case lastMessage
        case lastActivity
    }
    
    convenience init(identifier: String,
                     with data: [String: Any],
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        name = data[CodingKeys.name.rawValue] as? String ?? ""
        lastMessage = data[CodingKeys.lastMessage.rawValue] as? String
        
        let timestamp = data[CodingKeys.lastActivity.rawValue] as? Timestamp
        lastActivity = timestamp?.dateValue()
    }
    
    var about: String {
        let description = "\(String(describing: name)), identifier: \(String(describing: identifier)) \n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? Message }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}

// MARK: - Message

extension Message {
    
    enum CodingKeys: String, CodingKey {
        case content
        case created
        case senderId
        case senderName
    }
    
    convenience init(identifier: String,
                     with data: [String: Any],
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        content = data[CodingKeys.content.rawValue] as? String ?? ""
        senderId = data[CodingKeys.senderId.rawValue] as? String ?? ""
        senderName = data[CodingKeys.senderName.rawValue] as? String ?? ""

        let timestamp = data[CodingKeys.created.rawValue] as? Timestamp
        created = timestamp?.dateValue() ?? Date()
    }
    
    var about: String {
        return "message: \(String(describing: content)), created: \(String(describing: created))"
    }
}
