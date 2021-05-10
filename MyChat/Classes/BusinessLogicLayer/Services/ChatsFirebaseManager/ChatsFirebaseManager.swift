//
//  ChatsFirebaseManager.swift
//  MyChat
//
//  Created by Administrator on 14.04.2021.
//

import Foundation
import Firebase
import CoreData

// MARK: - ChatsFirebaseManager

class ChatsFirebaseManager {

    // MARK: - Initialization

    init() {}

    // MARK: - Static methods

    static func getChannelFirebaseManager(
        coreDataStack: CoreDataStackProtocol?,
        reference: CollectionReference?) -> FirebaseManagerProtocol {
        return FirebaseManager(
            coreDataStack: coreDataStack, reference: reference, fetchRequest: Channel.fetchRequest())
    }

    static func getMessageFirebaseManager(
        coreDataStack: CoreDataStackProtocol?,
        reference: CollectionReference?,
        channel: Channel?) -> FirebaseManagerProtocol {
        return FirebaseManager(
            coreDataStack: coreDataStack, reference: reference, fetchRequest: Message.fetchRequest(), channel: channel)
    }
}
