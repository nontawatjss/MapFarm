//
//  AllAreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 3/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import GoogleMaps
import Foundation
import FirebaseFirestore

class AllAreaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var AreaDistance: UILabel!
    
    @IBOutlet weak var PriceAll: UILabel!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "พื้นที่ทั้งหมด"
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.AreaAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AreaCell
        
        cell.NameArea.text = "\(appDelegate.AreaAll[indexPath.item]["Aname"]!)"
        

        
        // Create a rectangular path
        let rect = GMSMutablePath()

        
        var LL = [GeoPoint]()
        
        LL = appDelegate.AreaAll[indexPath.item]["Apath"]! as! [GeoPoint]

        var lat = 0.0
        var long = 0.0
        
        var i = 0
        while i < LL.count {
            
            print("\(LL[i].latitude)")
            
            rect.add(CLLocationCoordinate2D(latitude: LL[i].latitude, longitude: LL[i].longitude))
            
            lat = lat + LL[i].latitude
            long = long + LL[i].longitude
            
            i = i + 1
        }
        
        lat = (lat/Double(LL.count))
        long = (long/Double(LL.count))

      
        let polygon = GMSPolygon(path: rect)
        
        
        //ImageIcon
        var j = 0
        var imageIcon = ""
        var ColorArea:UIColor!
        while j < appDelegate.PlanType.count  {
            
            if "\(appDelegate.AreaAll[indexPath.item]["Atype"]!)" == "\(appDelegate.PlanType[j]["Pname"]!)" {
                imageIcon = "\(appDelegate.PlanType[j]["Ppic"]!)"
                ColorArea = UIColor.yellow.withAlphaComponent(0.7)
            }else {
                imageIcon = "faq"
               ColorArea = UIColor.clear
            }
            j = j + 1
        }
        
        
        
        // Create the polygon, and assign it to the map.
        polygon.fillColor = ColorArea
        polygon.strokeColor = .red
        polygon.strokeWidth = 1.5
        polygon.map = cell.MapView
        
        var zoom = Float("\(appDelegate.AreaAll[indexPath.item]["Azoom"]!)")

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: zoom!-1)
        
        cell.MapView.mapType = GMSMapViewType.satellite
        cell.MapView.camera = camera
        
        
        cell.MapView.isUserInteractionEnabled = false
        
        cell.addSubview(addCartIcon(nameImage: imageIcon, widthCell: Int(cell.frame.width)))
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = ((CollectionView.frame.width/2)-2)
        
        return CGSize(width: w, height: w)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
        
        appDelegate.selectID = "\(appDelegate.AreaAll[indexPath.item]["Aid"]!)"
        performSegue(withIdentifier: "goArea", sender: self)
        
        
    }
    
    func addCartIcon(nameImage:String,widthCell:Int) -> UIImageView{

        let ImageView = UIImageView(frame: CGRect(x: widthCell-45, y: 0, width: 45 , height: 45))
        
        let image = UIImage(named: nameImage)
        ImageView.contentMode = .scaleAspectFit
        ImageView.image = image
      
        
        return ImageView
        
    }
    
    
    
    
}
