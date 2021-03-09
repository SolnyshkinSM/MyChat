//
//  ThemesViewController.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

// MARK: - ThemesViewControllerProtocol

protocol ThemesViewControllerProtocol {
    
    var delegate: ThemesPickerDelegate? { get set }
    var closure: (_ color: UIColor) -> () { get set }
}

// MARK: - ThemesPickerDelegate

protocol ThemesPickerDelegate {
    
    func setBackgroundColor(_ color: UIColor)
}

// MARK: - ThemesViewController

class ThemesViewController: UIViewController, ThemesViewControllerProtocol {
    
    // MARK: - Public properties
    
    @IBOutlet var collectionButtons: [UIButton]!
    
    @IBOutlet var collectionLabels: [UILabel]!
    
    @IBOutlet weak var classicButoon: UIButton!
    
    @IBOutlet weak var dayButoon: UIButton!
    
    @IBOutlet weak var nightButoon: UIButton!
    
    @IBOutlet weak var classicLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var nightLabel: UILabel!
    
    
    
    var currentTheme: Theme?
    
    var delegate: ThemesPickerDelegate?
    
    var closure: (UIColor) -> () = {_ in }
    
    private lazy var clousureTwo: (() -> ()) = {
        self.view.backgroundColor = .yellow
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTheme = Theme.current
        
        configureView()
        updateButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionButtons.forEach { button in
            button.layer.cornerRadius = button.bounds.height / 4
        }
    }
    
    deinit {
        //print("ThemesViewController deinit")
    }
    
    // MARK: - Public methods
    
    @IBAction func classicButoonPressing(_ sender: UIButton) {
        
        //delegate?.setBackgroundColor(.white)
        //closure(.white)
        
        if let selectedTheme = Theme(rawValue: 0) {
            selectedTheme.apply()
        }
        
        updateButtons()
        reloadView()
    }
    
    @IBAction func dayButoonPressing(_ sender: Any) {
        
        //delegate?.setBackgroundColor(.yellow)
        //closure(view.backgroundColor!)
        //clousureTwo()
        
        if let selectedTheme = Theme(rawValue: 1) {
            selectedTheme.apply()
        }
        
        updateButtons()
        reloadView()
    }
    
    @IBAction func nightButoonPressing(_ sender: UIButton) {
        
        //delegate?.setBackgroundColor(.black)
        //closure(.black)
        
        if let selectedTheme = Theme(rawValue: 2) {
            selectedTheme.apply()
        }
        
        updateButtons()
        reloadView()
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        title = "Settings"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelButoonPressing))
        navigationItem.rightBarButtonItem = cancelButton
        
        collectionLabels.forEach { label in
            label.isUserInteractionEnabled = true
            
            var action = #selector(updateButtons)
            switch label {
            case classicLabel: action = #selector(classicButoonPressing)
            case dayLabel: action = #selector(dayButoonPressing)
            case nightLabel: action = #selector(nightButoonPressing)
            default:
                break
            }
            
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        }
    }
    
    @objc
    private func updateButtons() {
        
        collectionButtons.forEach { button in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
                    
        collectionButtons[Theme.current.rawValue].layer.borderWidth = 2
        collectionButtons[Theme.current.rawValue].layer.borderColor = UIColor.blue.cgColor
    }
    
    @objc
    func cancelButoonPressing(_ sender: UIBarItem) {
        
        if currentTheme != Theme.current {
            currentTheme?.apply()
            reloadView()
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func reloadView() {
        
        view.window?.reload()
        navigationController?.view.window?.reload()
    }
}
