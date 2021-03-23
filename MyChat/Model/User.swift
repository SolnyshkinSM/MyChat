//
//  User.swift
//  MyChat
//
//  Created by Administrator on 11.03.2021.
//

import Foundation

// MARK: - UserProtocol

protocol UserProtocol {
    var name: String? { get set }
    var unreadMessage: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessage: Bool { get set }
}

// MARK: - User

struct User: UserProtocol {
    var name: String?
    var unreadMessage: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool
}
