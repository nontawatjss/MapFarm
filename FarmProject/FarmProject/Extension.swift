//
//  Extension.swift
//  FarmProject
//
//  Created by Nontawat on 16/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
