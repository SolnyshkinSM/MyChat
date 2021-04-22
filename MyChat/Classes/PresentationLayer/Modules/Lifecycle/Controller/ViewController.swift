//
//  ViewController.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        PrintManager.shared.printLifecycleEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PrintManager.shared.printLifecycleEvent()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        PrintManager.shared.printLifecycleEvent()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        PrintManager.shared.printLifecycleEvent()
    }
}
