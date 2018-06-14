//
//  ViewController.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 26/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import UIKit

struct Login: Codable {
    let email: String
    let password: String
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.setIndicatorColor(UIColor.brown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action(_ sender: UIButton) {
        
    }


}


