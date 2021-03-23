//
//  Message.swift
//  MyChat
//
//  Created by Administrator on 11.03.2021.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Message

struct Message: Identifiable, Codable {

    @DocumentID public var id: String?

    // let identifier: String?
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?

    /*enum CodingKeys: String, CodingKey {
        case identifier
        case content
        case created
        case senderId
        case senderName
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try? container.decode(String.self, forKey: .identifier)
        content = try? container.decode(String.self, forKey: .content)
        created = try? container.decode(Date.self, forKey: .created)
        senderId = try? container.decode(String.self, forKey: .senderId)
        senderName = try? container.decode(String.self, forKey: .senderName)
    }*/
}
