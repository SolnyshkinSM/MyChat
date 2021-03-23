//
//  ThemesViewController.swift
//  MyChat
//
//  Created by Administrator on 06.03.2021.
//

import UIKit

// MARK: - ThemesViewController

class ThemesViewController: UIViewController {

    // MARK: - Public properties

    @IBOutlet var collectionButtons: [UIButton]!

    @IBOutlet var collectionLabels: [UILabel]!

    @IBOutlet weak var classicButoon: UIButton!

    @IBOutlet weak var dayButoon: UIButton!

    @IBOutlet weak var nightButoon: UIButton!

    @IBOutlet weak var classicLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var nightLabel: UILabel!

    var themeManager: ThemeManager?

    var closure: ((Theme) -> Void)?

    // MARK: - Private properties

    private var currentTheme: Theme?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        currentTheme = themeManager?.currentTheme

        configureView()
        updateButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionButtons.forEach { button in
            button.layer.cornerRadius = button.bounds.height / 4
        }
    }
    
    // MARK: - Public methods

    @IBAction func themeButoonPressing(_ sender: AnyObject) {

        let rawValue = ((sender as? UITapGestureRecognizer) != nil)
            ? (sender as? UITapGestureRecognizer)?.view?.tag
            : (sender as? UIButton)?.tag

        if let selectedTheme = Theme(rawValue: rawValue ?? 0) {

            // Изменение темы приложения
            // themeManager?.applyTheme(selectedTheme)
            closure?(selectedTheme)

            // retain cycle может возникнуть:

            // 1. Если установить текущий ViewController в качестве свойства themeManager
            // themeManager?.currentViewController = self

            // 2. Если в closure использовать strong захват
            // themeManager?.closureRetainCycle()

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
    }

    private func updateButtons(theme: Theme? = nil) {

        collectionButtons.forEach { button in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }

        let rawValue = theme != nil ? theme?.rawValue : themeManager?.currentTheme.rawValue
        collectionButtons[rawValue ?? 0].layer.borderWidth = 2
        collectionButtons[rawValue ?? 0].layer.borderColor = UIColor.blue.cgColor
    }

    @objc
    private func cancelButoonPressing(_ sender: UIBarItem) {

        if currentTheme != themeManager?.currentTheme {
            themeManager?.applyTheme(currentTheme ?? .default)
            reloadView()
        }
        navigationController?.popViewController(animated: true)
    }

    private func reloadView() {

        view.window?.reload()
        navigationController?.view.window?.reload()
    }    
}
