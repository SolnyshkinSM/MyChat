//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Administrator on 21.02.2021.
//

import UIKit

// MARK: - ProfileViewController

class ProfileViewController: UIViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var profileImageButton: UIButton!
        
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
     
    @IBOutlet weak var editButoon: UIButton!
    
    @IBOutlet weak var closeButoon: UIButton!
    
    @IBOutlet weak var myProfileLabel: UILabel!
        
    // MARK: - Private properties
    
    private let theme = ThemeManager.shared.currentTheme
    
    private var profile: ProfileProtocol = Profile(
        name: "Marina",
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
        
        //print(#function + " Edit butoon frame: \(editButoon.frame)")
        
        profileImageButton.layer.masksToBounds = true
        
        nameLabel.text = profile.fullname
        detailsLabel.text = profile.details
        
        
        let renderer = UIGraphicsImageRenderer(size: profileImageButton.bounds.size)
        let image = renderer.image { (context) in
            
            context.stroke(renderer.format.bounds)
            #colorLiteral(red: 0.8941176471, green: 0.9098039216, blue: 0.168627451, alpha: 1).setFill()
            context.fill(renderer.format.bounds)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let font = UIFont.systemFont(ofSize: profileImageButton.bounds.height * 0.6)
            let offset = font.capHeight - font.ascender
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: offset,
                .kern: 0
            ]
            
            let initialsString = String(profile.name.prefix(1)) + String(profile.lastname.prefix(1))
            initialsString.draw(with: renderer.format.bounds, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }
        
        profileImageButton.setBackgroundImage(image, for: .normal)
        profileImageButton.backgroundColor = theme.profileImageButtonColor
        
        barView.backgroundColor = theme.barViewColor
        editButoon.backgroundColor = theme.buttonBackgroundColor
        editButoon.setTitleColor(theme.buttonTintColor, for: .normal)
        closeButoon.backgroundColor = .clear
        myProfileLabel.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(#function + " Edit butoon frame: \(editButoon.frame)")
        /*viewDidLoad вызывается когда View загружено но еще не помещено в иерархию представлений, поэтому отображаются размеры из раскадровки (Storyboard).
         После добавления View в иерархию представлений, отображается реалиный размер элемента.
         */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
          
        actionSheet.setBackgroundColor(color: theme.buttonBackgroundColor)
        
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
        }
        
        dismiss(animated: true)
    }
}
