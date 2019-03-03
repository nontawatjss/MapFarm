//
//  AllAreaViewController.swift
//  FarmProject
//
//  Created by Nontawat on 3/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import GoogleMaps

class AllAreaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var AreaDistance: UILabel!
    
    @IBOutlet weak var PriceAll: UILabel!
    
    
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AreaCell
        
        cell.NameArea.text = "แปลง \(indexPath.item+1)"
        

        
        // Create a rectangular path
        let rect = GMSMutablePath()

        rect.add(CLLocationCoordinate2D(latitude: 15.237350, longitude: 104.843238))
        rect.add(CLLocationCoordinate2D(latitude: 15.236702, longitude: 104.844286))
        rect.add(CLLocationCoordinate2D(latitude: 15.236600, longitude: 104.843479))
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor.white.withAlphaComponent(0.5)
        polygon.strokeColor = .red
        polygon.strokeWidth = 2
        polygon.map = cell.MapView
        
        var lat = (15.237350 + 15.236702 + 15.236600)/3.0
        var long = (104.843238 + 104.844286 + 104.843479)/3.0
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        cell.MapView.mapType = GMSMapViewType.satellite
        cell.MapView.camera = camera
        
        
        cell.MapView.isUserInteractionEnabled = false
        
        cell.addSubview(addCartIcon(nameImage: "cornIcon", widthCell: Int(cell.frame.width)))
        
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
        
        
    }
    
    func addCartIcon(nameImage:String,widthCell:Int) -> UIImageView{

        let ImageView = UIImageView(frame: CGRect(x: widthCell-40, y: 2, width: 45 , height: 45))
        
        let image = UIImage(named: nameImage)
        ImageView.contentMode = .scaleAspectFit
        ImageView.image = image
      
        
        return ImageView
        
    }
    
    
}
