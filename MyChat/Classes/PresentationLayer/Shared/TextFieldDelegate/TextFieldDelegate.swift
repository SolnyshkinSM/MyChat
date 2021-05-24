//
//  TextFieldDelegate.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit

// MARK: - TextFieldDelegate

class TextFieldDelegate: NSObject, TextFieldDelegateProtocol {

    // MARK: - Private properties

    private let textFieldShouldReturnHandler: (_ textField: UITextField) -> Void

    // MARK: - Initialization

    init(textFieldShouldReturnHandler: @escaping (_ textField: UITextField) -> Void) {
        self.textFieldShouldReturnHandler = textFieldShouldReturnHandler
    }

    // MARK: - Public methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textFieldShouldReturnHandler(textField)

        textField.resignFirstResponder()
        return true
    }
}
