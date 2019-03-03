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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 18.0)
        
        MapView.mapType = GMSMapViewType.satellite
        MapView.camera = camera
    
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let newImage = resizeImage(image: UIImage(named: "push-pin")!, targetSize: CGSize(width: 30, height: 30))
        
        let markerView = UIImageView(image: newImage)
    
        markerView.tintColor = UIColor.red
        
        marker.iconView = markerView
        
        marker.map = MapView
        

        CustomView()

    }
    
    
    func CustomView() {
        CancelBT.isHidden = true
        RefreshAreaBT.isHidden = true

    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
          print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        
        if tapMap == true {
        
        mapView.clear()
   
        self.path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        positionMarker.append(["lat": Double(coordinate.latitude), "long": Double(coordinate.longitude)])
        
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
            
            let newImage = resizeImage(image: UIImage(named: "placeholder-3")!, targetSize: CGSize(width: 30, height: 30))
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
       // appDelegate.selectID = marker.snippet!
     //  performSegue(withIdentifier: "goArea", sender: self)
        
        UIGraphicsBeginImageContext(MapView.frame.size);
        MapView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var screenShot = UIGraphicsGetImageFromCurrentImageContext()
        var imaView = UIImageView(image: resizeImage(image: screenShot!, targetSize: CGSize(width: 50.0, height: 50.0)))
        MapView.addSubview(imaView)
        UIGraphicsEndImageContext()
        
        return true
        
        
    }


    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title? = "i Farm"
        print("IN")
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

        tapMap = false
        
    }
    
    @IBAction func REfreshAction(_ sender: Any) {
        
        MapView.clear()
        path = GMSMutablePath()
        
        positionMarker.removeAll()
        
    }
    
    @IBAction func AddCompleteAction(_ sender: Any) {
        
        if ComoleteAdd == false {
            CancelBT.isHidden = false
            RefreshAreaBT.isHidden = false
            AddAreaBT.setImage(UIImage(named: "checked-1"), for: .normal)
            ComoleteAdd = true
            print("Add")
    
            path = GMSMutablePath()
           
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
            
            
            tapMap = false
            
            
        }
        
        
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
