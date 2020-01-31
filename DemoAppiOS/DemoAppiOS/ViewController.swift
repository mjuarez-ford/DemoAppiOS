//
//  ViewController.swift
//  DemoAppiOS
//
//  Created by AppLink on 02.05.19.
//  Copyright © 2019 AppLink. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var AlertButton: UIButton!
    var latitude:Double = 50.953303
    var longitude:Double = 6.920917
    var sumSend:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProxyManager.sharedManager.connect()
    }

    @IBAction func sendLocation(_ sender: Any) {
        
        if(sumSend == 0.0){
            ProxyManager.sharedManager.subscribeSL()
        }
        
        latitude = latitude + sumSend
        longitude = longitude + sumSend

        ProxyManager.sharedManager.sendLocation(lat: 50.953303, long: 6.920917, name: "Gravenreuthstrassa\(sumSend)")
        
        sumSend = sumSend + 1.0
    }
    
    @IBAction func sendAlert(_ sender: Any) {
        ProxyManager.sharedManager.sendAlert()
    }
    
}

