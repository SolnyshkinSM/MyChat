//
//  Section.swift
//  MyChat
//
//  Created by Administrator on 11.03.2021.
//

import Foundation

// MARK: - SectionProtocol

protocol SectionProtocol {
    var name: String  { get set }
    var online: Bool  { get set }
}

// MARK: - Section

struct Section: SectionProtocol {
    var name: String
    var online: Bool
}
