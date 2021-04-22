//
//  ProfileViewController.swift
//  MyChat
//
//  Created by Administrator on 21.02.2021.
//

import UIKit

// MARK: - ProfileViewController

class ProfileViewController: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var barView: UIView!

    @IBOutlet weak var profileImageButton: UIButton!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var detailsTextField: UITextField!

    @IBOutlet var collectionField: [UITextField]!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var saveGCDButton: UIButton!

    @IBOutlet weak var saveOperationsButton: UIButton!

    @IBOutlet var saveCollectionButtons: [UIButton]!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var editButoon: UIButton! {
        didSet { editButoon.layer.cornerRadius = editButoon.bounds.height / 2 }
    }

    @IBOutlet weak var closeButoon: UIButton!

    @IBOutlet weak var myProfileLabel: UILabel!
    
    // MARK: - Public properties
    
    public var coordinator: GoToCoordinatorProtocol?

    // MARK: - Private properties

    private var profile: Profile?

    private let theme = ThemeManager.shared.currentTheme

    private var fileLoader: FileLoaderProtocol = GCDFileLoader.shared

    private var fileLoaderOperation: FileLoaderProtocol = OperationFileLoader.shared

    lazy private var loadClosure = { [weak self] (result: Result<Profile, Error>) -> Void in

        switch result {
        case .success(let profile):
            self?.profile = profile
            self?.configureProfile(profile: profile)
        case .failure(let error):
            self?.profile = Profile()
            let alert = UIAlertController(title: "Error", message: "Failed to load data")
            let repeatButton = UIAlertAction(title: "Repeat", style: .default, handler: { _ in
                self?.loadProfile()
            })
            alert.addAction(repeatButton)
            if error as? FileWorkManagerError == FileWorkManagerError.readError {
                self?.present(alert, animated: true)
            }
        }
        self?.activityIndicator.stopAnimating()
    }
    
    lazy private var textFieldDelegate: TextFieldDelegateProtocol = TextFieldDelegate { [weak self] textField in
        
        if textField == self?.collectionField.last {
            textField.resignFirstResponder()
        } else {
            if let index = self?.collectionField.firstIndex(of: textField) {
                self?.collectionField[index + 1].becomeFirstResponder()
            }
        }
    }
    
    lazy private var pickerController: PickerControllerProtocol = PickerController(viewController: self) { [weak self] info in
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self?.profileImageButton.setBackgroundImage(image, for: .normal)
            self?.profileImageButton.backgroundColor = .clear
            
            self?.showSavePanel(true)
            [self?.saveGCDButton, self?.saveOperationsButton].forEach { $0?.isEnabled = true }
        }
        self?.dismiss(animated: true)
    }
    
    lazy private var imageSelectionManager: ImageSelectionManagerProtocol = ImageSelectionManager(
        viewController: self, pickerController: pickerController)
    
    lazy private var graphicsImageRenderer: GraphicsImageRendererProtocol = GraphicsImageRenderer()
    
    lazy private var moveTextFieldManager: MoveTextFieldProtocol = MoveTextFieldManager(view: self.view)
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            moveTextFieldManager,
            selector: #selector(moveTextFieldManager.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            moveTextFieldManager,
            selector: #selector(moveTextFieldManager.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        profileImageButton.configereCircleButton(theme: theme)
    }

    // MARK: - Public methods

    @IBAction func closeButoonPressing(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func editButoonPressing(_ sender: UIButton) {
        
        showSavePanel(true)
        nameTextField.becomeFirstResponder()
    }

    @IBAction func profileImageEdit(_ sender: UIButton) {
        imageSelectionManager.selectImageFromCameraOrPhotoLibrary()
    }

    @IBAction func cancelButtonPressing(_ sender: UIButton) {

        if let profile = self.profile { configureProfile(profile: profile) }

        editButoon.isHidden = false
        collectionField.forEach { $0.isEnabled = false }
        saveCollectionButtons.forEach { $0.isHidden = true }

        activityIndicator.stopAnimating()

        fileLoaderOperation.cancelAllOperations()
        fileLoader.cancelAllOperations()
    }

    @IBAction func saveGCDButtonPressing(_ sender: UIButton? = nil) {

        guard var profile = profile else { return }

        profile.fullname = nameTextField.text
        profile.details = detailsTextField.text
        profile.image = profileImageButton.backgroundImage(for: .normal)?.pngData()

        [saveGCDButton, saveOperationsButton, nameTextField, detailsTextField].forEach { $0.isEnabled = false }

        activityIndicator.startAnimating()
        fileLoader.writeFile(object: profile) { [weak self] in

            switch $0 {
            case .success(let isSaved):
                [self?.saveGCDButton, self?.saveOperationsButton].forEach { $0?.isEnabled = true }
                let alert = UIAlertController(title: "Data saved", okHandler: { _ in
                    self?.showSavePanel(false)
                })
                if isSaved { self?.present(alert, animated: true) }
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Failed to save data")
                let repeatButton = UIAlertAction(title: "Repeat", style: .default, handler: { _ in
                    self?.saveGCDButtonPressing(nil)
                })
                alert.addAction(repeatButton)
                self?.present(alert, animated: true)
            }
            self?.activityIndicator.stopAnimating()
        }
    }

    @IBAction func saveOperationsButtonPressing(_ sender: UIButton? = nil) {

        guard var profile = profile else { return }

        profile.fullname = nameTextField.text
        profile.details = detailsTextField.text
        profile.image = profileImageButton.backgroundImage(for: .normal)?.pngData()

        [saveGCDButton, saveOperationsButton, nameTextField, detailsTextField].forEach { $0.isEnabled = false }

        activityIndicator.startAnimating()
        fileLoaderOperation.writeFile(object: profile) { [weak self] in

            switch $0 {
            case .success(let isSaved):
                [self?.saveGCDButton, self?.saveOperationsButton].forEach { $0?.isEnabled = true }
                let alert = UIAlertController(title: "Data saved", okHandler: { _ in
                    self?.showSavePanel(false)
                })
                if isSaved { self?.present(alert, animated: true) }
            case .failure:
                let alert = UIAlertController(title: "Error", message: "Failed to save data")
                let repeatButton = UIAlertAction(title: "Repeat", style: .default, handler: { _ in
                    self?.saveOperationsButtonPressing(nil)
                })
                alert.addAction(repeatButton)
                self?.present(alert, animated: true)
            }
            self?.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Private methods

    private func configureView() {

        activityIndicator.color = theme.tintColor
        activityIndicator.hidesWhenStopped = true

        loadProfile()
        configureButtons()

        barView.backgroundColor = theme.barViewColor
        [closeButoon, myProfileLabel].forEach { $0.backgroundColor = .clear }

        nameTextField.setPlaceholder("Full name")
        detailsTextField.setPlaceholder("Detailed information")

        collectionField.forEach { $0.delegate = textFieldDelegate; $0.isEnabled = false }

        nameTextField.addTarget(self, action: #selector(changedNameField), for: .editingChanged)
        detailsTextField.addTarget(self, action: #selector(changedNameField), for: .editingChanged)
    }

    private func loadProfile() {

        activityIndicator.startAnimating()

        // GCDFileLoader
        // fileLoader.readFile(completion: loadClosure)

        // OperationfileLoader
        fileLoaderOperation.readFile(completion: loadClosure)
    }

    private func configureProfile(profile: Profile) {

        nameTextField.text = profile.fullname
        detailsTextField.text = profile.details

        if let imageData = profile.image, let image = UIImage(data: imageData) {
            profileImageButton.setBackgroundImage(image, for: .normal)
            return
        }
        
        var initialsString = "--"
        if let fullname = profile.fullname {
            initialsString = String(fullname.prefix(1))
            if let words = profile.fullname?.components(separatedBy: " "), words.count == 2 {
                initialsString += String(words[1].prefix(1))
            }
        }
        
        graphicsImageRenderer.drawSymbolsOnButton(button: profileImageButton, of: initialsString)
    }

    private func configureButtons() {

        editButoon.backgroundColor = theme.buttonBackgroundColor
        editButoon.setTitleColor(theme.buttonTintColor, for: .normal)

        saveCollectionButtons.forEach {
            $0.isHidden = true
            $0.backgroundColor = theme.buttonBackgroundColor
            $0.setTitleColor(theme.buttonTintColor, for: .normal)
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
        [saveGCDButton, saveOperationsButton].forEach { $0.isEnabled = false }
    }

    private func showSavePanel(_ show: Bool) {

        editButoon.isHidden = show
        collectionField.forEach { $0.isEnabled = show }
        saveCollectionButtons.forEach { $0.isHidden = !show }
    }

    @objc
    private func changedNameField() {

        [saveGCDButton, saveOperationsButton].forEach {
            $0.isEnabled =
                nameTextField.text?.isEmpty == false || detailsTextField.text?.isEmpty == false
        }
    }

    // MARK: - UIResponder

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UIViewControllerCoordinatorProtocol

extension ProfileViewController: UIViewControllerCoordinatorProtocol {}

// MARK: - SelectImagesDelegateProtocol

extension ProfileViewController: SelectImagesDelegateProtocol {
    
    func imagePickerHandler(image: UIImage) {
        
        self.profileImageButton.setBackgroundImage(image, for: .normal)
        self.profileImageButton.backgroundColor = .clear
        
        self.showSavePanel(true)
        [self.saveGCDButton, self.saveOperationsButton].forEach { $0.isEnabled = true }
        
        self.dismiss(animated: true)
    }
}
