//
//  MapTestViewController.swift
//  FarmProject
//
//  Created by Nontawat on 1/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import MapKit

class MapTestViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMapKit: MKMapView!
    
    var lat = 15.237031
    var long = 104.843363
    var TY = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myMapKit.delegate = self
        myMapKit.mapType = .hybrid
        
        createPolygon()
        
        
        self.myMapKit.removeAnnotations(self.myMapKit.annotations)
        
       createPolygon()
    }
    
    func createPolygon() {
        
        let pinLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
       let mapCamera = MKMapCamera(lookingAtCenter: pinLocation, fromDistance: 2000, pitch: 75, heading: 180)
        
        let pinLocation2 = CLLocationCoordinate2D(latitude: lat+0.02, longitude: long+0.02)
        
        myMapKit.setCamera(mapCamera, animated: true)
        
           addAnnotation(coordinate: pinLocation, title: "UBON", subtitle: "copyright", type: 0)

            
            addAnnotation(coordinate: pinLocation2, title: "UBONTOYOU", subtitle: "copyright", type: 0)
            
        addPolygon()
    }
    
    
    func addPolygon() {
        
        var locations = [CLLocationCoordinate2D(latitude: 15.245558, longitude: 104.833312),
                         CLLocationCoordinate2D(latitude: 15.243932, longitude: 104.834631),
                         CLLocationCoordinate2D(latitude: 15.247555, longitude: 104.842214)]
      
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        myMapKit.addOverlay(polygon)
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.white.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 1
            return renderer
        }
        
        return MKOverlayRenderer()
    }
        
    
    
    private func addAnnotation(coordinate coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type:Int) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        TY = type
        myMapKit.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "file")
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let btCustom = UIButton(type: .detailDisclosure)
            btCustom.setImage(UIImage(named: "home"), for: .normal)
            btCustom.tintColor = UIColor.red
            annotationView.leftCalloutAccessoryView = btCustom
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        guard let annotation = view.annotation, let title = annotation.title else { return }
        
        let alertController = UIAlertController(title: "Welcome to \(title)", message: "You've selected \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }

    


    
}
