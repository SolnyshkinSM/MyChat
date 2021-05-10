//
//  ImageSelectionManager.swift
//  MyChat
//
//  Created by Administrator on 10.04.2021.
//

import UIKit

// MARK: - ImageSelectionManager

class ImageSelectionManager: ImageSelectionManagerProtocol {

    // MARK: - Private properties

    private let viewController: UIViewControllerCoordinatorProtocol

    private let theme = ThemeManager.shared.currentTheme

    private let pickerController: PickerControllerProtocol

    // MARK: - Initialization

    init(viewController: UIViewControllerCoordinatorProtocol,
         pickerController: PickerControllerProtocol) {
        self.viewController = viewController
        self.pickerController = pickerController
    }

    // MARK: - Public methods

    func selectImageFromCameraOrPhotoLibrary() {

        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        let loadingIcon = #imageLiteral(resourceName: "loading")

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

        actionSheet.addAction(camera)
        actionSheet.addAction(photo)

        let loading = UIAlertAction(title: "Loading", style: .default) { [weak self] _ in
            if let delegate = self?.viewController as? SelectImagesDelegateProtocol {
                self?.viewController.coordinator?.goToSelectImagesViewController(delegate: delegate)
            }
        }
        loading.setValue(loadingIcon, forKey: "image")
        loading.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        actionSheet.addAction(loading)

        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
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
