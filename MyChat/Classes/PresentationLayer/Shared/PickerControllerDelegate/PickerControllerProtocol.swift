//
//  PickerControllerProtocol.swift
//  MyChat
//
//  Created by Administrator on 12.04.2021.
//

import UIKit

// MARK: - PickerControllerProtocol

protocol PickerControllerProtocol: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType)
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
}
