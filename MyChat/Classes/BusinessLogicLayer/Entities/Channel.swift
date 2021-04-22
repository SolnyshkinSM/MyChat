//
//  Channel.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import Foundation
import CoreData
import Firebase

// MARK: - Channel

extension Channel {
    
    // MARK: - Enums
    
    enum CodingKeys: String, CodingKey {
        case name
        case lastMessage
        case lastActivity
    }
    
    // MARK: - Initialization
    
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
    
    // MARK: - Public properties
    
    var about: String {
        let description = "\(String(describing: name)), identifier: \(String(describing: identifier)) \n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? Message }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}
