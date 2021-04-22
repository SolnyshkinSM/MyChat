//
//  FirebaseManagerProtocol.swift
//  MyChat
//
//  Created by Administrator on 11.04.2021.
//

import Foundation
import Firebase

// MARK: - FirebaseManagerProtocol

protocol FirebaseManagerProtocol {
    func addSnapshotListener() -> ListenerRegistration?
}
