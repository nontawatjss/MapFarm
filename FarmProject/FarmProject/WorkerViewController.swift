//
//  WorkerViewController.swift
//  FarmProject
//
//  Created by Nontawat on 13/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class WorkerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "ผู้ปฏิบัติงาน"
    }

}
