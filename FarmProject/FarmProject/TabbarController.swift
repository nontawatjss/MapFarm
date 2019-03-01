//
//  TabbarController.swift
//  FarmProject
//
//  Created by Nontawat on 11/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      //  tabBar.barTintColor = UIColor.white
        
        setTabBarItems()
        
        tabBar.barTintColor = UIColor.white
         tabBar.tintColor = UIColor(red: 0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)
        
        tabBar.unselectedItemTintColor = UIColor(red: 73.0/255.0, green: 80.0/255.0, blue: 87.0/255.0, alpha: 0.7)
    
        //navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    

    func setTabBarItems(){
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        
        myTabBarItem1.image = self.resizeImage(image: UIImage(named: "house")!, targetSize: CGSize(width: 27.0, height: 27.0))
        myTabBarItem1.title = "หน้าแรก"
        myTabBarItem1.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: -6, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = self.resizeImage(image: UIImage(named: "information-2")!, targetSize: CGSize(width: 27.0, height: 27.0))
        myTabBarItem2.title = "แจ้งเตือน"
        myTabBarItem2.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = self.resizeImage(image: UIImage(named: "geo_fence")!, targetSize: CGSize(width: 27.0, height: 27.0))
        myTabBarItem3.title = "คนงาน"
        myTabBarItem3.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: -6, right: 0)
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = self.resizeImage(image: UIImage(named: "user-2")!, targetSize: CGSize(width: 27.0, height: 27.0))
        myTabBarItem4.title = "บัญชีผู้ใช้"
        myTabBarItem4.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: -6, right: 0)
        
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
