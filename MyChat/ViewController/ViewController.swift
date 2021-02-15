//
//  ViewController.swift
//  MyChat
//
//  Created by Administrator on 14.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        printApplicationMovedFrom_("WillLoad", to: "DidLoad", method: #function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printApplicationMovedFrom_("Disappeared", to: "Appearing", method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printApplicationMovedFrom_("Appearing", to: "Appeared", method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printApplicationMovedFrom_("Appeared", to: "WillLayoutSubviews", method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printApplicationMovedFrom_("DidLayoutSubviews", to: "Appeared", method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printApplicationMovedFrom_("Appeared", to: "Disappearing", method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printApplicationMovedFrom_("Disappearing", to: "Disappeared", method: #function)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        printApplicationMovedFrom_("Appeared", to: "Transition", method: #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printApplicationMovedFrom_("Appeared", to: "MemoryWarning", method: #function)
    }
}

