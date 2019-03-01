//
//  RegisterViewController.swift
//  FarmProject
//
//  Created by Nontawat on 12/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var ViewRegister: UIView!
    
    @IBOutlet weak var CloseBT: UIButton!
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var RePassword: UITextField!
    
    @IBOutlet weak var Fname: UITextField!
    
    @IBOutlet weak var Lname: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    
    
    @IBOutlet weak var RegisterBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomView()
    }
    
    func CustomView(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        ViewRegister.layer.cornerRadius = 5.0
        RegisterBT.layer.cornerRadius = 5.0
        
    }
    
    func addUser() {
        
        if Username.text! != "" && Password.text! != "" && RePassword.text! != "" && Fname.text! != "" && Lname.text! != "" && Email.text! != "" {
            
            if Password.text! == RePassword.text! {
   
                let db = Firestore.firestore()
                
                var checkuser = false
                //read check username
                db.collection("DBUser").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            if self.Username.text! == "\(document.data()["username"]!)" {
                                checkuser = true
                            }
                            
                        }
                        
                        
                        if checkuser == false {
                            
                            // Add a new document with a generated ID
                            var ref: DocumentReference? = nil
                            ref = db.collection("DBUser").addDocument(data: [
                                "username": self.Username.text!,
                                "password": self.RePassword.text!,
                                "email": self.Email.text!,
                                "fname": self.Fname.text!,
                                "lname": self.Lname.text!,
                                "pic": "",
                                "user_from": "from_username",
                                "user_type": "user_manager"
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Add New Username ")
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                            
                        }else{
                             print("ผู้บัญชีมีอยู่ในระบบแล้ว")
                        }
                        
                        
                    }
                }
                
                
                
            }else{
               
                print("รหัสผ่านไม่ตรงกัน")
                
            }
            
            
        }else{
            print("กรอกให้ครบทุกช่อง")
        }
    
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func RegisterAction(_ sender: Any) {
        
        addUser()
        
    }
}
