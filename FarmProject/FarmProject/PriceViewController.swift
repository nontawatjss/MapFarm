//
//  PriceViewController.swift
//  FarmProject
//
//  Created by Nontawat Kanboon on 10/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit
import Kanna
import  Alamofire

class PriceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.scrapeNYCMetalScene()
       

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "ราคาสินค้าเกษตรกรรม"
        print("ok")
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        backButton.tintColor = UIColor.white
        
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
    
    
    
    func scrapeNYCMetalScene() -> Void {
        Alamofire.request("https://goo.gl/yPTRwW").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
       
        if let doc = try? HTML(html: html, encoding: .utf8) {
           // print(doc.title)
            
            
            // Search for nodes by XPath
         
            
            for show in doc.css("td[class^='xl98']") {
                
               // print("\(show.text)")
            
                
                if Double(show.text!) != nil {
                    print("Price : \(Double(show.text!)!)")
                }
                
                
            }
        }
        
    }
    


}
