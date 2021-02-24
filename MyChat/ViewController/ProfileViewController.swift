//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Administrator on 21.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Public properties

    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var firstCharacterName: UILabel!
    
    @IBOutlet weak var firstCharacterLastname: UILabel!    
        
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
     
    @IBOutlet weak var editButoon: UIButton!
    
    // MARK: - Private properties
    
    var profile = Profile(name: "Marina",
                          lastname: "Dudarenko",
                          details: "UX/UI designer, web-designer, Moscow, Russia")
        
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print(editButoon.frame)
        //На данном этапе создания View еще нет ни самой View, ни ее свойств.
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function + " Edit butoon frame: \(editButoon.frame)")
        
        profileImageButton.layer.masksToBounds = true
        
        nameLabel.text = profile.fullname
        detailsLabel.text = profile.details
        firstCharacterName.text = String(profile.name.prefix(1))
        firstCharacterLastname.text = String(profile.lastname.prefix(1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function + " Edit butoon frame: \(editButoon.frame)")
        /*viewDidLoad вызывается когда View загружено но еще не помещено в иерархию представлений, поэтому отображаются размеры из раскадровки (Storyboard).
         После добавления View в иерархию представлений, отображается реалиный размер элемента.
         */
    }
    
    override func viewDidLayoutSubviews() {
        profileImageButton.layer.cornerRadius = profileImageButton.bounds.height / 2
        editButoon.layer.cornerRadius = editButoon.bounds.height / 2
    }
    
    // MARK: - Public methods
        
    @IBAction func closeButoonPressing(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func editButoonPressing(_ sender: UIButton) {
    }
    
    @IBAction func profileImageEdit(_ sender: UIButton) {
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
                
        present(actionSheet, animated: true)
             
        
        actionSheet.view.subviews.forEach { (subview) in
            for constraint in subview.constraints {
                if constraint.constant < 0 {
                    constraint.isActive = false
                }
            }
        }
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let pickerController = UIImagePickerController()
            pickerController.allowsEditing = true
            pickerController.sourceType = source
            pickerController.delegate = self
            
            present(pickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageButton.setBackgroundImage(image, for: .normal)
            profileImageButton.backgroundColor = .clear
            
            firstCharacterName.isHidden = true
            firstCharacterLastname.isHidden = true
        }
        
        dismiss(animated: true)
    }
}
