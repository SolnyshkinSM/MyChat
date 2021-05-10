//
//  ChatsCoreDataStack.swift
//  MyChat
//
//  Created by Administrator on 14.04.2021.
//

import Foundation

// MARK: - ChatsCoreDataStack

class ChatsCoreDataStack {

    // MARK: - Initialization

    init() {}

    // MARK: - Static methods

    static func getCoreDataStack() -> CoreDataStackProtocol {
        return CoreDataStack(dataBaseName: "Chats")
    }
}
