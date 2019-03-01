//
//  AreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 24/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AreaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var StatusDay: UILabel!
    
    @IBOutlet weak var AreaName: UILabel!
    
    @IBOutlet weak var TypePlate: UILabel!
    @IBOutlet weak var AreaPrice: UILabel!
    
    @IBOutlet weak var DeleteAreaBT: UIButton!

    @IBOutlet weak var AreaDateStart: UILabel!
    @IBOutlet weak var AreaDistanc: UILabel!
    
    @IBOutlet weak var EditAreaBT: UIButton!
    @IBOutlet weak var CloseBT: UIButton!
    
    @IBOutlet weak var ViewArea: UIView!
    
    @IBOutlet weak var TableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var AreaID = ""
    var TaskOrder = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Area Detail"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        CustomView()
        TableView.delegate = self
        TableView.dataSource = self
        showAreaDetail()
        showTask()
    }
    
   func CustomView(){
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    ViewArea.layer.cornerRadius = 5.0
    EditAreaBT.layer.cornerRadius = 5.0
    DeleteAreaBT.layer.cornerRadius = 5.0
    TableView.layer.cornerRadius = 10.0
//    TableView.layer.borderWidth = 1.0
//    TableView.layer.borderColor = UIColor.black.cgColor
    TableView.allowsSelection = false
    }
   
    @IBAction func CloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showTask() {

        
        TableView.reloadData()
        
    }
    
    func showAreaDetail() {
    
        let db = Firestore.firestore()
        
        var checkuser = false
        //read check username
        db.collection("DBArea").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    if self.appDelegate.selectID == document.documentID {
                        print("\(document.documentID)")
  
                        self.AreaID = "\(document.documentID)"
                        self.AreaName.text = "\(document.data()["Aname"]!)"
                        self.TypePlate.text = "\(document.data()["Atype"]!)"
                        self.AreaPrice.text = "\(document.data()["Aprice"]!) บาท"
                                    let area = document.data()["Adistanc"]! as! Double
                                    let area2 = area*0.000625
                        self.AreaDistanc.text = String(format: "%.02f ไร่" ,area2)
                        
                        
                        
                                    let dateFormatter : DateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                    let strDate = dateFormatter.string(from: document.data()["Adate"] as! Date)
                        
                                    let sdate = Date()
                                    let fdate = document.data()["Adate"] as! Date
                                    let calendar = Calendar.current
                                    let date1 = calendar.startOfDay(for: fdate)
                                    let date2 = calendar.startOfDay(for: sdate)
                        
                                    let components = calendar.dateComponents([.day], from: date1, to: date2)
                        
                                    print("DAY \(components.day)")
                        
                        self.StatusDay.text = "\(components.day!) วัน"
                        
                        self.AreaDateStart.text = "\(strDate)"
                    }
                    
                }
                
            }
        }
        
    }
    
    @IBAction func DeleteAreaAction(_ sender: Any) {

        
        
        let db = Firestore.firestore()
        
        db.collection("DBArea").document("\(AreaID)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("reloadMap"), object: nil)
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
  
    @IBAction func EditAreaAction(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        
        
        cell.TNo.text = "\(indexPath.item+1)"
        cell.TName.text = "\(TaskOrder[indexPath.item]["name"]!)"
        
        let dateFormatter : DateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = TaskOrder[indexPath.item]["date"]! as! Date
        let dateString = dateFormatter.string(from: date)
      
        cell.TDate.text = "\(dateString)"
        
       
    
        cell.BTDetail.tag = indexPath.item
        cell.BTDetail.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)

        return cell
    }
    
    @objc func buttonClicked(sender: UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
    }
    
}
