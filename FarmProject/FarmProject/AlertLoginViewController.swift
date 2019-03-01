//
//  AlertLoginViewController.swift
//  FarmProject
//
//  Created by Nontawat on 12/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore


class AlertLoginViewController: UIViewController {

    @IBOutlet weak var ActivityLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var CloseBT: UIButton!
    
    @IBOutlet weak var UsernameInput: UITextField!
    
    @IBOutlet weak var ViewAlertLogin: UIView!
    @IBOutlet weak var PasswordInput: UITextField!
    
    @IBOutlet weak var LoginBT: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            CustomView()
      
        
    }
    
    func CustomView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        ViewAlertLogin.layer.cornerRadius = 5.0
        LoginBT.layer.cornerRadius = 5.0
    
    
    }
    
    @IBAction func LoginAction(_ sender: Any) {
      
        CheckUser()
        
    }
    
    func CheckUser() {
        
        self.ActivityLoading.startAnimating()
        
        if UsernameInput.text! != "" && PasswordInput.text! != "" {
            
            let db = Firestore.firestore()
            
            var checkuser = false
            //read check username
            db.collection("DBUser").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if self.UsernameInput.text! == "\(document.data()["username"]!)" && self.PasswordInput.text! == "\(document.data()["password"]!)" {
                            checkuser = true
                        }
                        
                    }
                    
                    
                    if checkuser == true {
                        
                        print("Login Success")
                        
                      UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                         UserDefaults.standard.set("\(self.UsernameInput.text!)", forKey: "UsernameNow")
                        
                        self.dismiss(animated: true, completion: nil)
                      
                        NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: nil)
                        
                        
                    }else{
                        print("Login Fail")
                        self.ActivityLoading.stopAnimating()
                    }
                    
                    
                }
            }
            
            
            
        }else{
            
            print("กรอกข้อมูลให้ครบทุกช่อง")
            
        }
        

        
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func ForgetPasswordAction(_ sender: Any) {
    }

    
}
