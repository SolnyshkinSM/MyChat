//
//  Profile.swift
//  MyChat
//
//  Created by Administrator on 24.02.2021.
//

import Foundation

// MARK: - ProfileProtocol

protocol ProfileProtocol {
    var name: String { get set }
    var lastname: String { get set }
    var details: String { get set }
    var fullname: String { get }
}

// MARK: - Profile

struct Profile: ProfileProtocol {
    var name: String
    var lastname: String
    var details: String
    var fullname: String { name + " " + lastname }
}
