//
//  ViewController.swift
//  KFCNotify
//
//  Created by Mani on 10/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RegionMonitor.shared.enableLocationServices()
        self.title = "Corona Restricted Places"
        self.startLocationMonitoring()
    }
    
    func startLocationMonitoring() {
        RegionMonitor.shared.startLocationMonitoring()
    }


}

