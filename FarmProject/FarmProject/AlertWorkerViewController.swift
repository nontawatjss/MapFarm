//
//  AlertWorkerViewController.swift
//  FarmProject
//
//  Created by Nontawat on 9/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore
import  NVActivityIndicatorView

class AlertWorkerViewController: UIViewController {
    
    @IBOutlet weak var ViewAll: UIView!
    
    @IBOutlet weak var BTClose: UIButton!
    @IBOutlet weak var iCode: UILabel!
    
    @IBOutlet weak var BTGen: UIButton!
    
    @IBOutlet weak var QRcodeImage: UIImageView!
    @IBOutlet weak var ViewIDLine: UIView!
    
     var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityIndicator:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let IndicatorSize:CGFloat = 120
        let IndicatorFram = CGRect(x: (view.frame.width-IndicatorSize)/2, y: (view.frame.height-IndicatorSize)/2, width: IndicatorSize, height: IndicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: IndicatorFram, type: .circleStrokeSpin, color: UIColor.gray, padding: 20.0)
        
        view.addSubview(activityIndicator)
        
        iCode.text = "\(appDelegate.UserDetail["iCode"]!)"
        
        CustomView()
        
    }
    
    func CustomView() {
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        ViewAll.layer.cornerRadius = 5.0
        
        ViewIDLine.layer.cornerRadius = 5.0
        ViewIDLine.layer.borderColor = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0).cgColor
        ViewIDLine.layer.borderWidth = 1.5
        
        QRcodeImage.layer.cornerRadius = 5.0
        QRcodeImage.layer.borderWidth = 1.5
        QRcodeImage.layer.borderColor =  UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0).cgColor
        
        BTGen.layer.cornerRadius = 5.0
  
        
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GeniCode(_ sender: Any) {
        self.activityIndicator.startAnimating()
        
        let newiCode = randomString(length: 4)
        
       
        
        let db = Firestore.firestore()
        
        let Ref = db.collection("DBUser").document("\(appDelegate.UserDetail["id"]!)")
        
        // Set the "capital" field of the city 'DC'
        Ref.updateData([
            "iCode": "\(newiCode)"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.iCode.text = "\(newiCode)"
                 self.appDelegate.UserDetail["iCode"] = "\(newiCode)"
            }
            self.activityIndicator.stopAnimating()
        }
        
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    
}
