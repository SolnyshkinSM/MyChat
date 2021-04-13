//
//  Message.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import Foundation
import CoreData
import Firebase

// MARK: - Message

extension Message {
    
    // MARK: - Enums
    
    enum CodingKeys: String, CodingKey {
        case content
        case created
        case senderId
        case senderName
    }
    
    // MARK: - Initialization
    
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
    
    // MARK: - Public properties
    
    var about: String {
        return "message: \(String(describing: content)), created: \(String(describing: created))"
    }
}
