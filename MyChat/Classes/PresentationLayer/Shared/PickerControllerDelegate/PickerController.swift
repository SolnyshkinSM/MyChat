//
//  PickerController.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - PickerController

class PickerController: NSObject, PickerControllerProtocol {

    // MARK: - Private properties

    private let viewController: UIViewController

    private let didFinishPickingMediaHandler: (_ info: [UIImagePickerController.InfoKey: Any]) -> Void

    // MARK: - Initialization

    init(viewController: UIViewController,
         didFinishPickingMediaHandler: @escaping (_ info: [UIImagePickerController.InfoKey: Any]) -> Void) {
        self.viewController = viewController
        self.didFinishPickingMediaHandler = didFinishPickingMediaHandler
    }

    // MARK: - Public methods

    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.sourceType = source
            pickerController.delegate = self

            viewController.present(pickerController, animated: true)
        }
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        didFinishPickingMediaHandler(info)
    }
}
