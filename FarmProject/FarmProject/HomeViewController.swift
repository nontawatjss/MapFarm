//
//  HomeViewController.swift
//  FarmProject
//
//  Created by Nontawat on 1/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore
import NVActivityIndicatorView


class HomeViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var CollectionView: UICollectionView!
    
     var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityIndicator:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        let IndicatorSize:CGFloat = 120
        let IndicatorFram = CGRect(x: (view.frame.width-IndicatorSize)/2, y: (view.frame.height-IndicatorSize)/2, width: IndicatorSize, height: IndicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: IndicatorFram, type: .ballPulse, color: UIColor.gray, padding: 20.0)
        
        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        

        
        getUserDetail(username: UserDefaults.standard.string(forKey: "UsernameNow")!)
        print("Usernow \(UserDefaults.standard.string(forKey: "UsernameNow")!)")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "หน้าแรก"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
        
       
        
        switch indexPath.item {
        case 0:
            cell.NameCell.text = "i-Farm"
            cell.ImageCell.image = UIImage(named: "map-2")
             break
        case 1:
            cell.NameCell.text = "ราคาสินค้าเกษตร"
            cell.ImageCell.image = UIImage(named: "best-price")
             break
        case 2:
            cell.NameCell.text = "แจ้งเตือน"
            cell.ImageCell.image = UIImage(named: "information-2")
            cell.ImageCell.addSubview(addCartIcon(i: 7, widthCell: Int(cell.ImageCell.frame.width)))
            break
        case 3:
            cell.NameCell.text = "คนงาน"
            cell.ImageCell.image = UIImage(named: "Farmermer")
            cell.ImageCell.tintColor = UIColor.red
             break
        case 4:
            cell.NameCell.text = "พื้นที่ของคุณ"
            cell.ImageCell.image = UIImage(named: "map-1")
            cell.ImageCell.tintColor = UIColor.red
            break
        case 5:
            cell.NameCell.text = "สภาพอากาศ"
            cell.ImageCell.image = UIImage(named: "temperature")
            cell.ImageCell.tintColor = UIColor.red
            break
        default:
            print("NoWay")
        }
        
        return cell
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = ((CollectionView.frame.width/3)-2)
        
        return CGSize(width: w, height: w)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        
        switch indexPath.item {
        case 0:
            print(indexPath.item)
            self.tabBarController?.selectedIndex = 1
            break
        case 1:
           print(indexPath.item)
            break
        case 2:
            print(indexPath.item)
             performSegue(withIdentifier: "goMap", sender: self)
            break
        case 3:
            print(indexPath.item)
            break
        case 4:
            print(indexPath.item)
            performSegue(withIdentifier: "goAllArea", sender: self)
            break
        default:
            print("NoWay")
           
        }
        
    }
    
    
    

    
    
    func addCartIcon(i:Int,widthCell:Int) -> UILabel{
        // badge label
        
        
       var label = UILabel(frame: CGRect(x: widthCell-13, y: -7, width: 26 , height: 26))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "SukhumvitSet-Medium", size: 20)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        label.text = "\(i)"
        
        return label
        
    }
    
    
    func getUserDetail(username:String) {
    
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
                        
                        self.appDelegate.UserDetail["id"] = "\(document.documentID)"
                        self.appDelegate.UserDetail["username"] = "\(document.data()["username"]!)"
                        self.appDelegate.UserDetail["password"] = "\(document.data()["password"]!)"
                        self.appDelegate.UserDetail["fname"] = "\(document.data()["fname"]!)"
                        self.appDelegate.UserDetail["lname"] = "\(document.data()["lname"]!)"
                        self.appDelegate.UserDetail["email"] = "\(document.data()["email"]!)"
                        self.appDelegate.UserDetail["pic"] = "\(document.data()["pic"]!)"
                        
                    }
                }
            }
            
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
        }
        
        
    }
    
    

}
