//
//  AccountViewController.swift
//  FarmProject
//
//  Created by Nontawat on 23/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var PicUser: UIImageView!
    
    @IBOutlet weak var NameUser: UILabel!
    
    @IBOutlet weak var TableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.separatorColor = UIColor.clear

        let url = URL(string: "\(appDelegate.UserDetail["pic"]!)")
        PicUser.kf.setImage(with: url)
        
        TableView.isScrollEnabled = false
        
        PicUser.layer.masksToBounds = true
        PicUser.layer.cornerRadius = 10.0
        PicUser.layer.borderWidth = 3.0
        PicUser.layer.borderColor = UIColor(red: 0/255, green: 204/255, blue: 120/255, alpha: 1.0).cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "บัญชีผู้ใช้"
        
        NameUser.text = "สวัสดีคุณ \(appDelegate.UserDetail["fname"]!) \(appDelegate.UserDetail["lname"]!)"
    
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AccountCell
        
      
        
        switch indexPath.item {
        case 0:
            print("0")
            cell.NameLable.text = "ข้อมูลผู้ใช้"
            cell.ImageCell.image = UIImage(named: "user-4")
            break
        case 1:
            print("0")
            cell.NameLable.text = "เกี่ยวกับเรา"
            cell.ImageCell.image = UIImage(named: "help-1")
            break
        case 2:
            print("0")
            cell.NameLable.text = "ติดต่อเรา"
            cell.ImageCell.image = UIImage(named: "envelope-2")
            
            break
        case 3:
    
            cell.NameLable.text = "ออกจากระบบ"
            cell.ImageCell.image = UIImage(named: "logout")
            break
        default:
            break
        }
        
        cell.ImageCell.image = cell.ImageCell.image?.withRenderingMode(.alwaysTemplate)
        cell.ImageCell.tintColor = UIColor(red: 0/255, green: 204/255, blue: 120/255, alpha: 1.0)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.item {
        case 0:
            print("0")
         
            break
        case 1:
            print("0")
          
            break
            
        case 2:
            print("0")
            
            break
        case 3:
            print("0")
            
            FBSDKLoginManager().logOut()
            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
            
            dismiss(animated: true, completion: nil)
            
            break
        default:
            break
        }
        
        
    }
    


}
