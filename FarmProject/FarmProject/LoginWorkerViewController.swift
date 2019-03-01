//
//  LoginWorkerViewController.swift
//  FarmProject
//
//  Created by Nontawat on 16/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import Kanna
import SwiftyJSON
import CoreLocation
import NVActivityIndicatorView

class LoginWorkerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var PhoneIP: UITextField!
    @IBOutlet weak var LoginBT: UIButton!
    
    var shows: [String] = []
    
    let apiKey = "2a70b0a2e6e1a4eacd63f1c35887e6ff"
    var lat = 15.237031
    var long = 104.843363
    var activityIn:NVActivityIndicatorView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hideKeyboardWhenTap()
        
        let indicatoreSize:CGFloat = 200
        let indicatorFram = CGRect(x: (view.frame.width-indicatoreSize)/2, y:( view.frame.height-indicatoreSize)/2, width: indicatoreSize, height: indicatoreSize )
        activityIn = NVActivityIndicatorView(frame: indicatorFram, type: .circleStrokeSpin, color: UIColor.red, padding: 20.0)
        
        activityIn.backgroundColor = UIColor.white
        view.addSubview(activityIn)
        
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIn.startAnimating()
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.stopUpdatingLocation()
            
            
        }
        
        locationTest()
        
        
        
        //creatPolygon()
        
        
 //  self.scrapeNYCMetalScene()
    }
    
   
    
    func locationTest(){
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIn.stopAnimating()
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                // let jsonTemp = js
                
                print("\(jsonWeather)")
                
            }
            
    }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIn.stopAnimating()
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
               // let jsonTemp = js
                
                print("\(jsonWeather)")
                
            }
            
            
        }
        
    }
    
    func scrapeNYCMetalScene() -> Void {
        Alamofire.request("https://goo.gl/397wq7").responseString { response in
            print("ISSS \(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        // Finish this next
   
        if let doc = try? HTML(html: html, encoding: .utf8) {
            print(doc.title)
            
            
             //Search for nodes by XPath
            for link in doc.xpath("//td") {
                
                let str = "\(link["class"]!)"
                if str == "xl98" {
                    
                    if link.text! != "-" {
                       print(link.text!)
                    }
                    
                }

            }
    }
        
    
 
    }

    @IBAction func LoginAction(_ sender: Any) {
        
        guard let phoneNumber = PhoneIP.text else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (veritificatID, error) in
            
            if error == nil {
                
                print("\(veritificatID) Success")
                
            }else{
                print("Errorr", error?.localizedDescription)
                
            }
            
        }
        
        
    }
    
}
