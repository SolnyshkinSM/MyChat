//
//  ImageSelectionManager.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - ImageSelectionManager

class ImageSelectionManager {
    
    // MARK: - Private properties
    
    private let viewController: UIViewController
    
    private let theme = ThemeManager.shared.currentTheme
    
    private let pickerController: PickerControllerProtocol
    
    // MARK: - Initialization
    
    init(viewController: UIViewController,
         pickerController: PickerControllerProtocol) {
        self.viewController = viewController
        self.pickerController = pickerController
    }
    
    // MARK: - Public methods
    
    func selectImageFromCameraOrPhotoLibrary() {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.pickerController.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.pickerController.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)

        actionSheet.setBackgroundColor(color: theme.buttonBackgroundColor)

        viewController.present(actionSheet, animated: true)

        actionSheet.view.subviews.forEach { (subview) in
            for constraint in subview.constraints where constraint.constant < 0 {
                constraint.isActive = false
            }
        }
    }    
}
