//
//  NoConnectionVC.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 13/06/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

import UIKit

final class NoConnectionVC: UIViewController {

   @IBOutlet weak var imageViewMiddle: UIImageView!
   @IBOutlet weak var labelTitle: UILabel!
   @IBOutlet weak var labelSubtitle: UILabel!
    
    init() {
        super.init(nibName: "NoConnectionVC", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}

