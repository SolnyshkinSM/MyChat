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
    let name: String
    let lastMessage: String?
    //let lastActivity: Date?
}
