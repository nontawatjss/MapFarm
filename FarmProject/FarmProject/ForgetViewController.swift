//
//  ForgetViewController.swift
//  FarmProject
//
//  Created by Nontawat on 14/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit


class ForgetViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var BTChoose: UIButton!
    
    @IBOutlet weak var DropView:NSLayoutConstraint!
    
    @IBOutlet weak var TableView: UITableView!
    
    
    var isTableViewVisble = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        TableView.dataSource = self
        TableView.delegate = self
        TableView.separatorColor = UIColor.clear
        TableView.layer.cornerRadius = 5.0
        TableView.isScrollEnabled = false
        
        DropView.constant = 0
      
        BTChoose.layer.cornerRadius = 5.0

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DropCell
        
        cell.FName.text = "TESS"
        cell.ImgName.image = UIImage(named: "ic2")
        cell.LastName.text = "asdasd"
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.5){
            
            self.DropView.constant = 0
            self.isTableViewVisble = false
            self.view.layoutIfNeeded()
        }
        
    }
    

    @IBAction func ActionShow(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5){
            if self.isTableViewVisble == false {
            self.isTableViewVisble = true
                self.DropView.constant = 44.0 * 5.0
                print(self.TableView.rowHeight)
            }else{
                
                self.DropView.constant = 0
                self.isTableViewVisble = false
            }
            self.view.layoutIfNeeded()
        }
        
    }
}
