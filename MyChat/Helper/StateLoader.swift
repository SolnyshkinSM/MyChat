//
//  StateLoader.swift
//  MyChat
//
//  Created by Administrator on 18.03.2021.
//

import Foundation

// MARK: - StateLoader

enum StateLoader: String {
    
    case ready, executing, finished, cancelled
    
    fileprivate var keyPath: String {
        return "is" + rawValue.capitalized
    }
}
