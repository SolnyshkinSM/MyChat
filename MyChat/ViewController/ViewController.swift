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
        printApplicationMovedFrom("WillLoad", to: "DidLoad", method: #function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printApplicationMovedFrom("Disappeared", to: "Appearing", method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printApplicationMovedFrom("Appearing", to: "Appeared", method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printApplicationMovedFrom("Appeared", to: "WillLayoutSubviews", method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printApplicationMovedFrom("DidLayoutSubviews", to: "Appeared", method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printApplicationMovedFrom("Appeared", to: "Disappearing", method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printApplicationMovedFrom("Disappearing", to: "Disappeared", method: #function)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        printApplicationMovedFrom("Appeared", to: "Transition", method: #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printApplicationMovedFrom("Appeared", to: "MemoryWarning", method: #function)
    }
}

