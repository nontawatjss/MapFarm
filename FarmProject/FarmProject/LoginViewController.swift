//
//  LoginViewController.swift
//  FarmProject
//
//  Created by Nontawat on 12/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var ActivityLoding: UIActivityIndicatorView!
    
    @IBOutlet weak var LogoImage: UIImageView!
    
    @IBOutlet weak var BTLoginFacebook: UIButton!
    
    @IBOutlet weak var BTLoginUsername: UIButton!
    
    let loginManager = LoginManager()
    
    var UserData = [String: String]()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI Design All
        CustomView()
        
        //CheckUser
        CheckUserDefault()
        
        //Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoginSuccess(notification:)), name: Notification.Name("LoginSuccess"), object: nil)
       
    }
    
    @objc func LoginSuccess(notification: Notification){
      
        performSegue(withIdentifier: "goLogin", sender: self)
        
    }
    
    
    
    func CheckUserDefault() {
        
            // your code here
    
            if (FBSDKAccessToken.current()?.userID != nil) || (UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  
                    print("LogonFacebook")
                    self.performSegue(withIdentifier: "goLogin", sender: self)
                  
                }
                
            }else{
                print("notLogon")
            }
        
    }
    
    func CustomView(){
        
        
        BTLoginFacebook.layer.cornerRadius = 5.0
        BTLoginUsername.layer.cornerRadius = 5.0

    }
    
    @IBAction func LoginFBAction(_ sender: Any) {
        
        print("Login")
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self){ loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Login")
                self.getFBUserData()
                self.performSegue(withIdentifier: "goLogin", sender: self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("ID Username \(UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN"))")
//        print("ID Facebook \(FBSDKAccessToken.current()?.userID!)")
        print("In")
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    //print(result!)
                    let field = result! as? [String:Any]
                    
                    self.UserData["id"] = "\((field!["id"] as? String)!)"
                    self.UserData["email"] = "\((field!["email"] as? String)!)"
                    self.UserData["fname"] = "\((field!["first_name"] as? String)!)"
                    self.UserData["lname"] = "\((field!["last_name"] as? String)!)"
                    self.UserData["name"] = "\((field!["name"] as? String)!)"
                    self.UserData["pic"] = "https://graph.facebook.com/\((FBSDKAccessToken.current()?.userID)!)/picture?width=250&height=250"
                    
                    self.checkFBUserDB(username: "\(self.UserData["email"]!)")
                    
                }
            })
        }
        
        
        
    }
    
    func checkFBUserDB(username:String){
    
        
        let db = Firestore.firestore()
        
        var checkuser = false
        //read check username
        db.collection("DBUser").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if username == "\(document.data()["username"]!)" {
                        checkuser = true
                    }
                    
                }
                
                
                if checkuser == false {
                    
                    // Add a new document with a generated ID
                    var ref: DocumentReference? = nil
                    ref = db.collection("DBUser").addDocument(data: [
                        "username": username,
                        "password": self.UserData["id"]!,
                        "email": self.UserData["email"]!,
                        "fname": self.UserData["fname"]!,
                        "lname": self.UserData["lname"]!,
                        "pic": self.UserData["pic"]!,
                        "user_from": "from_facebook",
                        "user_type": "user_manager"
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Add New Username ")
                        }
                    }
                    
                }else{
                    print("Old Username")
                }
                
                
            }
        }
        
        
        UserDefaults.standard.set("\(username)", forKey: "UsernameNow")
        
    }
    
    
    
    
    @IBAction func LoginUsernameAction(_ sender: Any) {
        
       performSegue(withIdentifier: "goAlertLogin", sender: self)
    }
    
    @IBAction func RegisterAction(_ sender: Any) {
        
        performSegue(withIdentifier: "goRegister", sender: self)
        
    }
    
}
