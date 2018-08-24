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

struct ResponseLogin: Codable {
    
}



final class ViewController: UIViewController {
    
    let url = "https://www.google.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.enable()
        ProgressHUD.setCenter(position: .multiplier(0.9))
        ProgressHUD.setIndicatorColor(UIColor.brown)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func getTestFunc() {
        
        let restClient = SHRestClient(url)
        
        restClient.addHeader(key: "Authorization", value: "some value")
            .get(parameters: ["paramsKey":"value"])
            .fetchData(success: { (data, response)  in
                // Raw data fetched
            }) { (error) in
                //
        }
        
        let restClient2 = SHRestClient(url)
        restClient2.addHeaders(["header1": "value1",
                               "header2": "value2"])
            .get(parameters: nil)
            .fetchJSON(success: { (jsonFormattedData) in
                //
            }) { (error) in
                //
        }
        
        
    }
    
    func postTestFunc() {
        
        let loginData = Login(email: "g@g.com", password: "1234")
        
        let restClient = SHRestClient(url)
        restClient.post(encodable: loginData)
            .fetchJSON(decodeable: ResponseLogin.self, success: { (responseLogin) in
                //
            }) { (error) in
                //
        }
    }
    
    

    
    @IBAction func action(_ sender: UIButton) {
        postTestFunc()
    }


}


