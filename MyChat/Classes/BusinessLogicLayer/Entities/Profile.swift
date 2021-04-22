//
//  Profile.swift
//  MyChat
//
//  Created by Administrator on 24.02.2021.
//

import Foundation

// MARK: - Profile

struct Profile: Codable {
    var fullname: String?
    var details: String?
    var image: Data?
}
