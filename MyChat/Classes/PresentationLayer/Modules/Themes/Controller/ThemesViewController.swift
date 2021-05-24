//
//  ThemesViewController.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

// MARK: - ThemesViewController

class ThemesViewController: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet var collectionButtons: [UIButton]!

    @IBOutlet var collectionLabels: [UILabel]!

    @IBOutlet weak var classicButoon: UIButton!

    @IBOutlet weak var dayButoon: UIButton!

    @IBOutlet weak var nightButoon: UIButton!

    @IBOutlet weak var classicLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var nightLabel: UILabel!

    // MARK: - Public properties

    var themeManager: ThemeManagerProtocol = ThemeManager()

    // MARK: - Private properties

    private lazy var currentTheme = themeManager.currentTheme

    private lazy var gestureRecognizerManager = GestureRecognizerManager(view: view)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        updateButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionButtons.forEach { $0.layer.cornerRadius = $0.bounds.height / 4 }
    }

    // MARK: - Public methods

    @IBAction func themeButoonPressing(_ sender: AnyObject) {

        let rawValue = ((sender as? UITapGestureRecognizer) != nil)
            ? (sender as? UITapGestureRecognizer)?.view?.tag
            : (sender as? UIButton)?.tag

        if let selectedTheme = Theme(rawValue: rawValue ?? 0) {
            themeManager.applyTheme(selectedTheme)
            updateButtons(theme: selectedTheme)
        }

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
            label.addGestureRecognizer(UITapGestureRecognizer(
                                        target: self,
                                        action: #selector(themeButoonPressing(_:))))
        }

        let longPressRecognizer = UILongPressGestureRecognizer(
            target: gestureRecognizerManager,
            action: #selector(gestureRecognizerManager.longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
    }

    private func updateButtons(theme: Theme? = nil) {

        collectionButtons.forEach { button in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }

        let rawValue = theme != nil ? theme?.rawValue : themeManager.currentTheme.rawValue
        collectionButtons[rawValue ?? 0].layer.borderWidth = 2
        collectionButtons[rawValue ?? 0].layer.borderColor = UIColor.blue.cgColor
    }

    @objc
    private func cancelButoonPressing(_ sender: UIBarItem) {

        if currentTheme != themeManager.currentTheme {
            themeManager.applyTheme(currentTheme)
            reloadView()
        }
        navigationController?.popViewController(animated: true)
    }

    private func reloadView() {

        view.window?.reload()
        navigationController?.view.window?.reload()
    }
}
