//
//  AreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 24/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AreaViewController: UIViewController{
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "ข้อมูลพื้นที่"
        print("ok")
    }
    
}
