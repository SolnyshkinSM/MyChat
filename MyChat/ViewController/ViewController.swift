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
        printLifecycleEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLifecycleEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLifecycleEvent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLifecycleEvent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLifecycleEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLifecycleEvent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLifecycleEvent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        printLifecycleEvent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printLifecycleEvent()
    }
}

