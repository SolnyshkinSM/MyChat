//
//  String.swift
//  MyChat
//
//  Created by Administrator on 04.04.2021.
//

import Foundation

// MARK: - String

extension String {

    var blank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}
