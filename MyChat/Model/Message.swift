//
//  Message.swift
//  MyChat
//
//  Created by Administrator on 11.03.2021.
//

import Foundation
import Firebase

// MARK: - Message

struct Message: Codable {

    let content: String
    let created: Date
    let senderId: String
    let senderName: String

    enum CodingKeys: String, CodingKey {
        case content
        case created
        case senderId
        case senderName
    }

    init(_ data: [String: Any]) {

        content = data[CodingKeys.content.rawValue] as? String ?? ""
        senderId = data[CodingKeys.senderId.rawValue] as? String ?? ""
        senderName = data[CodingKeys.senderName.rawValue] as? String ?? ""

        let timestamp = data[CodingKeys.created.rawValue] as? Timestamp
        created = timestamp?.dateValue() ?? Date()
    }
}
