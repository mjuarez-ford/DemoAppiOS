//
//  ViewController.swift
//  DemoAppiOS
//
//  Created by AppLink on 02.05.19.
//  Copyright © 2019 AppLink. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProxyManager.sharedManager.connect()
    }


}

