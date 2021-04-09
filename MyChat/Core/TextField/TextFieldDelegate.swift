//
//  TextFieldDelegate.swift
//  MyChat
//
//  Created by Administrator on 09.04.2021.
//

import UIKit
import Firebase

// MARK: - TextFieldDelegate

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Private properties
    
    private let profile: Profile?
    
    private var reference: CollectionReference?
    
    private lazy var deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    // MARK: - Initialization
    
    init(profile: Profile?,
         reference: CollectionReference?) {
        self.profile = profile
        self.reference = reference
    }
    
    // MARK: - Public methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text, !text.isEmpty, !text.blank {

            let messageData: [String: Any] = [
                "content": text,
                "created": Date(),
                "senderId": deviceID ?? "",
                "senderName": profile?.fullname ?? ""
            ]
            
            _ = reference?.addDocument(data: messageData)
            
            textField.text = .none
        }

        textField.resignFirstResponder()
        return true
    }
}
