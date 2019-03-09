//
//  AreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 24/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SwiftyJSON
import Alamofire
import  NVActivityIndicatorView

class AreaViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var RainPercent: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var TempCurrent: UILabel!
    
    @IBOutlet weak var TempMax: UILabel!
    
    @IBOutlet weak var TempMin: UILabel!
    
    @IBOutlet weak var ScrollV: UIScrollView!
    
    
    @IBOutlet weak var NameWeather: UILabel!
    
    @IBOutlet weak var IconWeather: UIImageView!
    
    @IBOutlet weak var HeightTable: NSLayoutConstraint!
    @IBOutlet weak var TopView: UIView!
    
    @IBOutlet weak var CenterView: UIView!
    
    @IBOutlet weak var TableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activicator:NVActivityIndicatorView!
    
    let ApiKey = "cd606cc14b98bf607b795afa25e1cd50"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.isScrollEnabled = false
        
      
        
        let IndicatorSize:CGFloat = 120
        let IndicatorFram = CGRect(x: (view.frame.width-IndicatorSize)/2, y: (view.frame.height-IndicatorSize)/2, width: IndicatorSize, height: IndicatorSize)
        activicator = NVActivityIndicatorView(frame: IndicatorFram, type: .circleStrokeSpin, color: UIColor.gray, padding: 20.0)
        
        view.addSubview(activicator)
        
        print("ID : \(appDelegate.selectID)")
        
        loadDataAll()
        
        
        CenterView.layer.cornerRadius = 5.0
        TopView.layer.cornerRadius = 5.0
        TableView.layer.cornerRadius = 5.0
        TopView.layer.borderColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1.0).cgColor
        TopView.layer.borderWidth = 1.5
        
        CenterView.layer.borderColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1.0).cgColor
        CenterView.layer.borderWidth = 1.5
        
      
    }
    
    
    func loadDataAll(){
        
       // self.activicator.startAnimating()
        
       let idArea = "\(appDelegate.selectID)"
        
        print("\(idArea)")
        
        var i = 0
        while i < appDelegate.AreaAll.count {

            if "\(appDelegate.AreaAll[i]["Aid"]!)" == idArea {

                print("\(appDelegate.AreaAll[i]["Aid"]!)")
                print("\(idArea)")

                //Weather
                var LL = [GeoPoint]()
                LL = appDelegate.AreaAll[i]["Apath"]! as! [GeoPoint]

                
                var lat = 0.0
                var long = 0.0
                var j = 0
                while j < LL.count {

                    lat = lat + LL[j].latitude
                    long = long + LL[j].longitude

                    j = j + 1
                }

                lat = (lat/Double(LL.count))
                long = (long/Double(LL.count))
                loadWeatherArea(lat: lat, long: long)



            }
            
            print("Tesit \(appDelegate.AreaAll[i]["Aid"]!)")
            i = i + 1
        }
    
    }
    
    func loadWeatherArea(lat:Double, long:Double){
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(ApiKey)&units=metric").responseJSON {
            response in
            
            self.activicator.stopAnimating()
            if let reStr = response.result.value {
                let jsonResponse = JSON(reStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                
                print(jsonResponse)

                self.IconWeather.image = UIImage(named: "\(jsonWeather["icon"])")
                self.TempCurrent.text = "\(Measurement(value: Double("\(jsonTemp["temp"])")!, unit: UnitTemperature.celsius))"
                self.TempMax.text = "\(Measurement(value: Double("\(jsonTemp["temp_max"])")!, unit: UnitTemperature.celsius))"
                self.TempMin.text = "\(Measurement(value: Double("\(jsonTemp["temp_min"])")!, unit: UnitTemperature.celsius))"
                
                self.humidity.text = "\(jsonTemp["temp_min"]) %"
                self.RainPercent.text = "7 %"
                
                
                switch (jsonWeather["description"]) {
                case "light rain" :
                    self.NameWeather.text = "มีฝนตกเล็กน้อย"
                    break
                case "mist":
                    self.NameWeather.text = "มีหมอก"
                    break
                case "clear sky":
                    self.NameWeather.text = "ท้องฟ้าแจ่มใส"
                    break
                case "few clouds":
                    self.NameWeather.text = "มีเมฆน้อย"
                    break
                default:
                    break
                    
                }
                

                
                self.activicator.stopAnimating()
                
            }
            
        
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "ข้อมูลพื้นที่"
        print("ok")
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        backButton.tintColor = UIColor.white
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        HeightTable.constant = CGFloat(10*68)
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        
        
        cell.TitleName.text = "เตรียมดินสำหรับปลูก"
        cell.Daytask.text = "วันที่ 1-7"
        cell.Status.text = "ส่งแจ้งเตือน"
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Select \(indexPath.item)")
        
        let alert = UIAlertController(title: "ยืนยัน?", message: "ยืนยันการแจ้งเตือนไปยังคนงานหรือไม่", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { action in
            self.activicator.startAnimating()
            
            let myUrl = URL(string: "https://us-central1-line-bot-dd3ee.cloudfunctions.net/LineBotPush")
            
//            var i = 0
//            while i < 2 {
            
                Alamofire.request(URLRequest(url: myUrl!)).responseJSON { response in
                    
                    print(response.result)
                    
                    self.activicator.stopAnimating()
                    
                }
                
//                i = i + 1
//            }
            
           
        }))
        
        alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { action in
            
            print("ยกเลิก")
            
            
        }))
        
        self.present(alert, animated: true)
        

        
        
       
        
       
    }

}
