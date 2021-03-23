//
//  Channel.swift
//  MyChat
//
//  Created by Administrator on 21.03.2021.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Channel

struct Channel: Identifiable, Codable {

    @DocumentID public var id: String?

    // let identifier: String?
    let name: String
    let lastMessage: String?
    let lastActivity: Date?

    /*enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case lastMessage
        case lastActivity
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try? container.decode(String.self, forKey: .identifier)
        name = try? container.decode(String.self, forKey: .name)
        lastMessage = try? container.decode(String.self, forKey: .lastMessage)
        lastActivity = try? container.decode(Date.self, forKey: .lastActivity)
    }*/
}
