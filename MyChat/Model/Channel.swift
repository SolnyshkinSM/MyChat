//
//  Channel.swift
//  MyChat
//
//  Created by Administrator on 21.03.2021.
//

import Foundation
import Firebase

// MARK: - Channel

struct Channel {

    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?

    enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case lastMessage
        case lastActivity
    }

    init(identifier: String, with data: [String: Any]) {

        self.identifier = identifier
        name = data[CodingKeys.name.rawValue] as? String ?? ""
        lastMessage = data[CodingKeys.lastMessage.rawValue] as? String

        let timestamp = data[CodingKeys.lastActivity.rawValue] as? Timestamp
        lastActivity = timestamp?.dateValue()
    }
}
