//
//  WorkerViewController.swift
//  FarmProject
//
//  Created by Nontawat on 13/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore
import NVActivityIndicatorView

class WorkerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var BTAddUSer: UIButton!
    
    @IBOutlet weak var TableHight: NSLayoutConstraint!
    
    @IBOutlet weak var TableView: UITableView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityIndicator:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TableView.delegate = self
        TableView.dataSource = self
        TableView.isScrollEnabled = false
        TableView.separatorColor = UIColor.white
            BTAddUSer.layer.cornerRadius = 5.0
        
        
        
        let IndicatorSize:CGFloat = 120
        let IndicatorFram = CGRect(x: (view.frame.width-IndicatorSize)/2, y: (view.frame.height-IndicatorSize)/2, width: IndicatorSize, height: IndicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: IndicatorFram, type: .circleStrokeSpin, color: UIColor.gray, padding: 20.0)
        
        view.addSubview(activityIndicator)
        
        getWorkerAll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationItem.title = "คนงานในฟาร์ม"
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        backButton.tintColor = UIColor.white
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
    }
    

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        TableHight.constant = CGFloat(70.0 * Double(appDelegate.WorkerAll.count))
        
        return appDelegate.WorkerAll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkerCell
        
        
        
        let url = URL(string: "\(appDelegate.WorkerAll[indexPath.item]["pictureUrl"]!)")
        cell.ImageCell.kf.setImage(with: url)
        
        cell.ImageCell.layer.masksToBounds = true
        cell.ImageCell.layer.cornerRadius = 5.0
        
        var statusname = ""
        switch "\(appDelegate.WorkerAll[indexPath.item]["status"]!)" {
        case "wait":
            statusname = "รอการตรวจสอบ"
            cell.JobPosition.backgroundColor = UIColor.orange
          
           break
        case "accept":
            statusname = "สมาชิก"
            cell.JobPosition.backgroundColor = UIColor.green
         
            break
        default:
            print("NOWAY")
        }
         cell.JobPosition.layer.masksToBounds = true
        cell.JobPosition.textColor = UIColor.white
        cell.JobPosition.layer.cornerRadius = 5.0
        cell.JobPosition.text = "\(statusname)"
        
        
        cell.NameLine.text = "\(appDelegate.WorkerAll[indexPath.item]["displayName"]!)"
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    
    func getWorkerAll() {
        
        self.activityIndicator.startAnimating()
        
      appDelegate.WorkerAll.removeAll()
        
        let db = Firestore.firestore()
        
        db.collection("DBWorker").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    print("\(document.data()["displayName"]!)")
                    
                    
                    if self.appDelegate.UserDetail["id"]! == "\(document.data()["customerId"]!)" {
                        
                        
                        self.appDelegate.WorkerAll.append(["customerId": document.data()["customerId"]!,
                                                           "displayName": document.data()["displayName"]!,
                                                           "pictureUrl": document.data()["pictureUrl"]!,
                                                           "status": document.data()["status"]!,
                                                           "userId": document.data()["userId"]!
                            ])
                    
                        
                    }else{
                        
                    }
             
                    
                }
            }
            
            print("\(self.appDelegate.WorkerAll.count)")
            
            self.TableView.reloadData()
            
          self.activityIndicator.stopAnimating()
            
        }
        
        
    }
    
}
