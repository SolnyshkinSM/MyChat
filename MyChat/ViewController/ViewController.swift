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
        printLifecycleEvent("WillLoad", to: "DidLoad", method: #function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLifecycleEvent("Disappeared", to: "Appearing", method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLifecycleEvent("Appearing", to: "Appeared", method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLifecycleEvent("Appeared", to: "WillLayoutSubviews", method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLifecycleEvent("DidLayoutSubviews", to: "Appeared", method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLifecycleEvent("Appeared", to: "Disappearing", method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLifecycleEvent("Disappearing", to: "Disappeared", method: #function)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        printLifecycleEvent("Appeared", to: "Transition", method: #function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printLifecycleEvent("Appeared", to: "MemoryWarning", method: #function)
    }
}

