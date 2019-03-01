//
//  AddAreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 11/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseFirestore

class AddAreaViewController: UIViewController {

    @IBOutlet weak var ViewArea: UIView!
    @IBOutlet weak var CloseBT: UIButton!
    
    @IBOutlet weak var NameArea: UITextField!
    
    
    @IBOutlet weak var ValueMoney: UITextField!
    
    @IBOutlet weak var PickerDate: UIDatePicker!
    
    @IBOutlet weak var BTAddArea: UIButton!
    
    
    
    @IBOutlet weak var ic1: UIButton!
    
    @IBOutlet weak var ic2: UIButton!
    
    @IBOutlet weak var ic3: UIButton!
    
    @IBOutlet weak var ic4: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var AreaDate:Date!
    var TypeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

     view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        ViewArea.layer.cornerRadius = 5.0
        BTAddArea.layer.cornerRadius = 5.0
    

        let image = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        CloseBT.setImage(image, for: .normal)
        CloseBT.tintColor = UIColor.red
        
        
        
    }
    
    func InsertAreaData(Aname:String, Atype:String, Aprice:Int, Adate:Date,ADistanc:Double) {
 
        
        let db = Firestore.firestore()

        var ref: DocumentReference? = nil

        ref = db.collection("DBArea").addDocument(data: [
            "Aname": Aname,
            "Adistanc": ADistanc,
            "Aprice": Aprice,
            "Atype": Atype,
            "Adate": Adate,
            "user_id": appDelegate.UserDetail["id"]!,
            "LLdata": appDelegate.LLData
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Add New Area ")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func AddArea(_ sender: Any) {
        
        //print(appDelegate.LLData.count)
        //print(appDelegate.LLData)
        
        let lldata = appDelegate.LLData
        
        
        let areadistanc = appDelegate.AreaDistanc
        
        InsertAreaData(Aname: NameArea.text!, Atype: TypeName, Aprice: Int(ValueMoney.text!)!, Adate: AreaDate,ADistanc: areadistanc)
        
        
         appDelegate.LLData.removeAll()
    
         NotificationCenter.default.post(name: Notification.Name("reloadMap"), object: nil)
        
         dismiss(animated: true, completion: nil)
      
    }
    
    
    

    
    @IBAction func CloseArea(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
        
        appDelegate.LLData.removeAll()
        
        NotificationCenter.default.post(name: Notification.Name("reloadMap"), object: nil)
        
    }
    
    @IBAction func dateChange(_ sender: Any) {
        
//        let dateFormatter : DateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//
//        let strDate = dateFormatter.string(from: PickerDate.date)
        
         AreaDate = PickerDate.date
        
    }
    
    
    @IBAction func ic1Action(_ sender: Any) {
        clearBorder()
        ic1.layer.cornerRadius = 5.0
        ic1.layer.borderWidth = 1.0
        ic1.layer.borderColor = UIColor.green.cgColor
        TypeName = "ข้าวโพด"
    }
    
    
    @IBAction func ic2Action(_ sender: Any) {
        clearBorder()
        ic2.layer.masksToBounds = true
        ic2.layer.cornerRadius = 5.0
        ic2.layer.borderWidth = 1.0
        ic2.layer.borderColor = UIColor.green.cgColor
         TypeName = "มันสำปะหลัง"
    }
    
    @IBAction func ic3Action(_ sender: Any) {
        clearBorder()
        ic3.layer.masksToBounds = true
        ic3.layer.cornerRadius = 5.0
        ic3.layer.borderWidth = 1.0
        ic3.layer.borderColor = UIColor.green.cgColor
         TypeName = "อ้อย"
    }
    
    @IBAction func ic4Action(_ sender: Any) {
        clearBorder()
        ic4.layer.cornerRadius = 5.0
        ic4.layer.borderWidth = 1.0
        ic4.layer.borderColor = UIColor.green.cgColor

    }
    
    func clearBorder() {
        ic1.layer.borderColor = UIColor.clear.cgColor
        ic2.layer.borderColor = UIColor.clear.cgColor
        ic3.layer.borderColor = UIColor.clear.cgColor
        ic4.layer.borderColor = UIColor.clear.cgColor
         TypeName = "ข้าว"
    }
    
    
}
