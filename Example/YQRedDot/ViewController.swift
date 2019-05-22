//
//  ViewController.swift
//  YQRedDot
//
//  Created by wyqpadding@gmail.com on 05/22/2019.
//  Copyright (c) 2019 wyqpadding@gmail.com. All rights reserved.
//

import UIKit
import YQRedDot

class ViewController: UIViewController {

    @IBOutlet weak var redDot: YQRedDot!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        redDot.value = 89
        redDot.type = .solid
        
        redDot.showBadge(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

