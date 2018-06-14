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
        let newLogin = Login(email: "manivannan.bse@gmail.com", password: "adminpassword")
        
        let rest = SHRestClient("http://foodplus.bsedemo.com/api/auth/login/")
        
        rest.addHeaders(["":""])
            .post(encodable: newLogin)
            .proceedFetching(success: { (data, response) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers, .mutableLeaves])
                print(json)
            } catch {
                print(error)
            }
            
        }) { (error) in
            print(error.debugDescription)
        }
    }


}


