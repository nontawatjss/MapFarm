//
//  ViewController.swift
//  FarmProject
//
//  Created by Nontawat on 23/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import GoogleMaps
import Foundation
import FBSDKLoginKit
import FirebaseFirestore





class ViewController: UIViewController , GMSMapViewDelegate{

    @IBOutlet weak var AcLoding: UIActivityIndicatorView!
    
    
    var index:Int = 0
    var rect:GMSMutablePath!
    var polygon:GMSPolygon!
    var marker:GMSMarker!
    var listmap: [String: Double] = ["X": 0.0, "Y": 0.0]
    var colormap:UIColor!
    static var nameArea: String = ""
    var i = 0,x=0;
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        //getUserDetail
        getUserDetail(username: UserDefaults.standard.string(forKey: "UsernameNow")!)
        print("Usernow \(UserDefaults.standard.string(forKey: "UsernameNow")!)")
        
        appDelegate.mapView.delegate =  self
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMap(notification:)), name: Notification.Name("reloadMasdsp"), object: nil)

       
      
    }
    

    func CustomView() {
        var plusBT = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Plusclick))
        
        plusBT.image = UIImage(named: "home")
        tabBarController?.navigationItem.rightBarButtonItem = plusBT
        
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
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
                
                self.reloadDraw()
            }
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        
        tabBarController?.navigationItem.rightBarButtonItem = backButton
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Ui Design
        CustomView()
        
        tabBarController?.navigationItem.title? = "หน้าหลัก"
    }
    
    
    @objc func Plusclick(){
      
        
        print("Plus s")
        
        x = 1
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(Saveclick))
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        index = 0
        listmap["X"] = 0.0
        listmap["Y"] = 0.0
        
        // rect.removeAllCoordinates()
       rect = GMSMutablePath()
        marker = GMSMarker()
        polygon = GMSPolygon(path: rect)
        
            colormap = UIColor.white.withAlphaComponent(0.5)
       
        
       
    }
    
    
    
    @objc func Saveclick(){
        print("Save s")
       
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(Plusclick))
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 23.0/255.0, green: 172.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        
        
        performSegue(withIdentifier: "goAddArea", sender: self)
        
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    if x == 1 {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        listmap["X"] = coordinate.latitude + listmap["X"]!
        listmap["Y"] = coordinate.longitude + listmap["Y"]!
        self.index = self.index+1


         self.polygon.map = nil


        // Create a rectangular path

        rect.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        
     
        let data = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        appDelegate.LLData.append(data)
        
        print("\(coordinate.latitude)  IS \(coordinate.longitude)" )
//
//        // Create the polygon, and assign it to the map.


        self.polygon = GMSPolygon(path: rect)


        self.polygon.fillColor = UIColor.white.withAlphaComponent(0.4)
        self.polygon.strokeColor = UIColor.red.withAlphaComponent(0.3)
        self.polygon.strokeWidth = 3
        self.polygon.map = appDelegate.mapView

        print("Area \(GMSGeometryArea(rect))")
        appDelegate.AreaDistanc = GMSGeometryArea(rect)
        
    }else{
    
             print("didTap marker \(marker.title)")
            
    }
  
        
    }

    

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       
        print("\(marker.snippet!)")
        appDelegate.selectID = marker.snippet!
        performSegue(withIdentifier: "goArea", sender: self)
        
        
        return true
        
        
    }
    
    func getDis(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) {
        let Local1 = CLLocation(latitude: c1.latitude, longitude: c1.longitude)
        let Local2 = CLLocation(latitude: c2.latitude, longitude: c2.longitude)

        print("Distance \(Local1.distance(from: Local2))")
    }
    
   
    
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6. 15.236906, 104.843754
        let camera = GMSCameraPosition.camera(withLatitude: 15.236906, longitude: 104.843754, zoom: 16.0)
        
        appDelegate.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        appDelegate.mapView.delegate = nil
        
        appDelegate.mapView.mapType = GMSMapViewType.hybrid
        
       view = appDelegate.mapView
        
    }
    
    @objc func reloadMap(notification: Notification){
        appDelegate.mapView.clear()
       
        
        reloadDraw()
    }
    
    func reloadDraw() {
      
        let db = Firestore.firestore()
        
        var checkuser = false
        //read check username
        db.collection("DBArea").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               
                for document in querySnapshot!.documents {
                   
                    if self.appDelegate.UserDetail["id"]! == "\(document.data()["user_id"]!)" {
                        
                        
                        db.collection("DBPlant").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                
                                for document2 in querySnapshot!.documents {
                                    
                                    if "\(document.data()["Atype"]!)" == "\(document2.data()["Pname"]!)" {
                                        
                                        
                                        let LLdata = document.get("LLdata") as! Array<GeoPoint>
                                        
                                        self.appDelegate.LLData = LLdata
                                        
                                        
                                        self.drawArea(Name: "\(document.data()["Aname"]!)" ,ID: "\(document.documentID)", pic: "\(document2.data()["Ppic"]!)", color: "")
                                        
                                        self.appDelegate.LLData.removeAll()
                                        
                                        
                                    }
                                    
                                   
                                }
                                
                          
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }

                    
                }
                
            }
        }
        
        
        
        
    }
    
    func drawArea(Name:String, ID:String, pic:String , color:String) {
        
        var lat = Double()
        var long = Double()
        lat = 0.0
        long = 0.0
        
        // Create a rectangular path
        rect = GMSMutablePath()
        
        var i = 0
        while i < appDelegate.LLData.count {
          
            let point = self.appDelegate.LLData[i] as! GeoPoint
            
            rect.add(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
            lat = point.latitude + lat
            long = point.longitude + long

            i = i + 1
        }

        // Creates a marker in the center of the map.
        lat = lat/Double(appDelegate.LLData.count)
        long = long/Double(appDelegate.LLData.count)
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(Name)"
        marker.snippet = "\(ID)"
        let image = UIImage(named: "\(pic)")
        let size = CGSize(width: 55, height: 80)
        marker.icon = imageResize(image: image!, sizeChange: size)
        marker.map = appDelegate.mapView
        
        // Create the polygon, and assign it to the map.
        polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor.yellow.withAlphaComponent(0.4)
        polygon.strokeColor = UIColor.white.withAlphaComponent(0.3)
        polygon.strokeWidth = 3
        polygon.map = appDelegate.mapView
        rect.removeAllCoordinates()
        
    
    }
    
    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

