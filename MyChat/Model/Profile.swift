//
//  Profile.swift
//  MyChat
//
//  Created by Administrator on 24.02.2021.
//

import Foundation

// MARK: - Profile

struct Profile {
    let name: String
    let lastname: String
    let details: String
    var fullname: String {name + " " + lastname}
}
