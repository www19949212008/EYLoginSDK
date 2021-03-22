//
//  ViewController.swift
//  EYLoginDemo
//
//  Created by eric on 2021/3/19.
//

import UIKit
import EYLoginSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        EYLoginSDKManager.shared().initializeSDK()
    }


}

