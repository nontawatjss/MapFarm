//
//  ViewController.swift
//  FarmProject
//
//  Created by Nontawat on 23/1/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    var mapView:GMSMapView!
    var index:Int = 0
    var rect:GMSMutablePath!
    var polygon:GMSPolygon!
    var marker:GMSMarker!
    var listmap: [String: Double] = ["X": 0.0, "Y": 0.0]
    var colormap:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
        
        //loadView()
    }


    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6. 15.236906, 104.843754
        let camera = GMSCameraPosition.camera(withLatitude: 15.236906, longitude: 104.843754, zoom: 16.0)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = nil
        
        mapView.mapType = GMSMapViewType.satellite
        
        
        view = mapView
        
        
        // Creates a marker in the center of the map.
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 15.236906, longitude: 104.843754)
        marker.title = "Sentaku"
        marker.snippet = "Ubonratchatani"
        marker.map = mapView
        
        
        // Create a rectangular path
        let rect = GMSMutablePath()
        rect.add(CLLocationCoordinate2D(latitude: 15.240121, longitude: 104.842121))
        rect.add(CLLocationCoordinate2D(latitude: 15.239726, longitude: 104.845910))
        rect.add(CLLocationCoordinate2D(latitude: 15.234455, longitude: 104.845432))
        rect.add(CLLocationCoordinate2D(latitude: 15.235477, longitude: 104.840755))
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor.green.withAlphaComponent(0.5)
        polygon.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polygon.strokeWidth = 10
        polygon.map = mapView
        rect.removeAllCoordinates()
        
    }
    
}

