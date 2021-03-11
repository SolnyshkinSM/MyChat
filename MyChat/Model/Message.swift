//
//  Message.swift
//  MyChat
//
//  Created by Administrator on 11.03.2021.
//

import Foundation

// MARK: - MessageProtocol

protocol MessageProtocol {
    var text: String?  { get set }
    var inbox: Bool  { get set }
}

// MARK: - Message

struct Message: MessageProtocol {
    var text: String?
    var inbox: Bool
}

