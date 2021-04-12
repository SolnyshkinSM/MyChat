//
//  TextFieldDelegateProtocol.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import UIKit

// MARK: - TextFieldDelegateProtocol

protocol TextFieldDelegateProtocol: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}
