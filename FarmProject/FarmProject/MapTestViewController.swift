//
//  MapTestViewController.swift
//  FarmProject
//
//  Created by Nontawat on 1/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Firebase
import NVActivityIndicatorView

class MapTestViewController: UIViewController, GMSMapViewDelegate{

    @IBOutlet weak var MapView: GMSMapView!
    
    @IBOutlet weak var AddAreaBT: UIButton!
    
    @IBOutlet weak var RefreshAreaBT: UIButton!
    
    @IBOutlet weak var CancelBT: UIButton!
    
    var lat = 15.237031
    var long = 104.843363
    var TY = 8
    
    var ComoleteAdd = false
    var MarkerCenterLat:Double!
    var MarkerCenterLong:Double!
    
    var Polyline:GMSPolyline!
    var Polygon:GMSPolygon!
    var path:GMSMutablePath!
    var positionMarker = [[String:Double]]()
    var markerPoly:GMSMarker!
    
    var tapMap = false
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var AreaDate:Date!
    
    var activitor:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let IndicatorSize:CGFloat = 120
        let IndicatorFram = CGRect(x: (view.frame.width-IndicatorSize)/2, y: (view.frame.height-IndicatorSize)/2, width: IndicatorSize, height: IndicatorSize)
        activitor = NVActivityIndicatorView(frame: IndicatorFram, type: .ballPulse, color: UIColor.white, padding: 20.0)
        
        view.addSubview(activitor)
        
        MapView.delegate = self

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        
        MapView.mapType = GMSMapViewType.satellite
        MapView.camera = camera
    
        CustomView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMap(notification:)), name: Notification.Name("reloadMap"), object: nil)
        
       

    }
    
    
    
    func CustomView() {
        CancelBT.isHidden = true
        RefreshAreaBT.isHidden = true

    }
    
    @objc func reloadMap(notification: Notification){
        
        loadDrawMap()
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
          print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        
        if tapMap == true {
   
        self.path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        positionMarker.append(["lat": Double(coordinate.latitude), "long": Double(coordinate.longitude)])
           
        let data = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        appDelegate.LLData.append(data)
            
        
        appDelegate.AreaDistanc = GMSGeometryArea(path)
   
            
            
        Polyline = GMSPolyline(path: path)
        Polyline.strokeColor = UIColor.red
        Polyline.strokeWidth = 2.0
        Polyline.map = MapView
        
        
        Polygon = GMSPolygon(path: path)
        Polygon.strokeColor = UIColor.red
        Polygon.strokeWidth = 2.0
        Polygon.fillColor = UIColor.white.withAlphaComponent(0.7)

  
        Polygon.map = MapView
        
        
        var i = 0
        MarkerCenterLat = 0.0
        MarkerCenterLong = 0.0
        while i < positionMarker.count {

            markerPoly = GMSMarker()
            
            markerPoly.position = CLLocationCoordinate2D(latitude: positionMarker[i]["lat"]!, longitude: positionMarker[i]["long"]!)
            
            let newImage = resizeImage(image: UIImage(named: "placeholder-3")!, targetSize: CGSize(width: 20, height: 20))
            let markerView = UIImageView(image: newImage)
            
            markerPoly.iconView = markerView
            
            markerPoly.map = MapView
            
            MarkerCenterLong = MarkerCenterLong + positionMarker[i]["long"]!
            MarkerCenterLat = MarkerCenterLat + positionMarker[i]["lat"]!
            
            i = i + 1
        }
            
            
        }else{
            
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("OKKKK")
        print(marker.snippet)
//
        appDelegate.selectID = marker.snippet!
       performSegue(withIdentifier: "goArea", sender: self)

        
        
        return true
        
        
    }


    
    func InsertAreaData(Aname:String, Atype:String, Aprice:Int,ADistanc:Double) {
        
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        
        let zoom = MapView.camera.zoom
        
        
        ref = db.collection("DBArea").addDocument(data: [
            "Aname": Aname,
            "Adistanc": ADistanc,
            "Aprice": Aprice,
            "Atype": Atype,
            "Azoom": zoom,
            "user_id": appDelegate.UserDetail["id"]!,
            "LLdata": appDelegate.LLData
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Add New Area ")
                
            }
        }
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "i Farm"
        print("IN")
        loadDrawMap()
    }
    
    
    
    @objc func AddnewArea() {
        
        print("test")
        
    }
    

    @IBAction func CancelAction(_ sender: Any) {
        
        AddAreaBT.setImage(UIImage(named: "add"), for: .normal)
        ComoleteAdd = false
        RefreshAreaBT.isHidden = true
        CancelBT.isHidden = true
        MapView.clear()

        positionMarker.removeAll()
        appDelegate.LLData.removeAll()
        
        tapMap = false
        
    }
    
    @IBAction func REfreshAction(_ sender: Any) {
        
        MapView.clear()
        path = GMSMutablePath()
        
        positionMarker.removeAll()
        appDelegate.LLData.removeAll()
        
    }
    
    @IBAction func AddCompleteAction(_ sender: Any) {
        
        if ComoleteAdd == false {
            CancelBT.isHidden = false
            RefreshAreaBT.isHidden = false
            AddAreaBT.setImage(UIImage(named: "checked-1"), for: .normal)
            ComoleteAdd = true
            print("Add")
    
            path = GMSMutablePath()
            
            positionMarker.removeAll()
            appDelegate.LLData.removeAll()
           
             tapMap = true
            
        }else{
            AddAreaBT.setImage(UIImage(named: "add"), for: .normal)
            ComoleteAdd = false
            RefreshAreaBT.isHidden = true
            CancelBT.isHidden = true
            print("Else")
            
            
            
            markerPoly = GMSMarker()
            
            markerPoly.position = CLLocationCoordinate2D(latitude: MarkerCenterLat/Double(positionMarker.count), longitude: MarkerCenterLong/Double(positionMarker.count))
            
            let newImage = resizeImage(image: UIImage(named: "cornIcon")!, targetSize: CGSize(width: 40, height: 80))
            let markerView = UIImageView(image: newImage)
            markerPoly.snippet = "Test"
            
            markerPoly.iconView = markerView
            
            
            markerPoly.map = MapView
            
            
            positionMarker.removeAll()
            
            
            //Insert พื้นที่
            InsertAreaData(Aname: "แปลงว่าง", Atype: "ข้าวโพด", Aprice: 340000, ADistanc: appDelegate.AreaDistanc)
            
            
            positionMarker.removeAll()
            appDelegate.LLData.removeAll()
            
            tapMap = false
            
            NotificationCenter.default.post(name: Notification.Name("reloadArea"), object: nil)
            
    
        }
        
        
    }
    
    func loadDrawMap() {
        
        MapView.clear()
        
        activitor.startAnimating()
        
        var i = 0
        while i < appDelegate.AreaAll.count {
        
            path = GMSMutablePath()
        
            var lat = 0.0
            var long = 0.0
            
            var LL = [GeoPoint]()
            LL = appDelegate.AreaAll[i]["Apath"]! as! [GeoPoint]
            
            var j = 0
            while j < LL.count {
                
                path.add(CLLocationCoordinate2D(latitude: LL[j].latitude, longitude: LL[j].longitude))
                
                lat = lat + LL[j].latitude
                long = long + LL[j].longitude
                j = j + 1
            }
            
            
            Polygon = GMSPolygon(path: path)
            
            
            
            markerPoly = GMSMarker()
            
            markerPoly.position = CLLocationCoordinate2D(latitude: lat/Double(LL.count), longitude: long/Double(LL.count))
            
            //ImageIcon
            var k = 0
            var imageIcon = ""
            var ColorArea:UIColor!
            while k < appDelegate.PlanType.count  {
                
                if "\(appDelegate.AreaAll[i]["Atype"]!)" == "\(appDelegate.PlanType[k]["Pname"]!)" {
                    imageIcon = "\(appDelegate.PlanType[k]["Ppic"]!)"
                    ColorArea = UIColor.yellow.withAlphaComponent(0.7)
                }else {
                    imageIcon = "faq"
                    ColorArea = UIColor.clear
                }
                k = k + 1
            }

            let newImage = resizeImage(image: UIImage(named: imageIcon)!, targetSize: CGSize(width: 40, height: 80))
            let markerView = UIImageView(image: newImage)
            
            markerPoly.snippet = "\(appDelegate.AreaAll[i]["Aid"]!)"
            
            markerPoly.iconView = markerView
            
            
            markerPoly.map = MapView
            
            
            Polygon.strokeColor = UIColor.red
            Polygon.strokeWidth = 2.0
            Polygon.fillColor = ColorArea
            Polygon.map = MapView
            
            
            i = i + 1
        }
        
      
        activitor.stopAnimating()
        
        
        
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
}
