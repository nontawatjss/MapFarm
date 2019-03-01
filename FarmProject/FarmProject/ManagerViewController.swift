//
//  ManagerViewController.swift
//  FarmProject
//
//  Created by Nontawat on 23/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var countdownTimer: Timer!
    var totalTime = 120

        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
         tableView.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
       startTimer()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "ตารางงาน"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    
    @objc func updateTime() {
       
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
        tableView.reloadData()
        
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManagerCell
        
        if indexPath.item == 0 {
            cell.NoLabel.text = "ลำดับ"
            cell.NoLabel.textColor = UIColor.white
            cell.AreaLable.text = "สถานที่"
            cell.AreaLable.textColor = UIColor.white
            cell.TimeOutLable.text = "เวลาที่เหลือ"
            cell.TimeOutLable.textColor = UIColor.white
            cell.backgroundColor = UIColor(red: 23/255, green: 172/255, blue: 230/255, alpha: 1.0)
            cell.BTdetail.isHidden = true
        }else{
            cell.backgroundColor = UIColor.white
        cell.NoLabel.text = "\(indexPath.item)"
        cell.AreaLable.text = "Area \(indexPath.item)"
        cell.TimeOutLable.text = "\(timeFormatted(totalTime))"
          cell.BTdetail.isHidden = false
        }
        
    
         cell.separatorInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
         cell.layer.cornerRadius = 10.0
     return cell
    }
    

}
