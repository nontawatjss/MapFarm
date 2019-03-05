//
//  TaskCell.swift
//  FarmProject
//
//  Created by Nontawat on 13/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var TitleName: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    @IBOutlet weak var Daytask: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        Daytask.layer.cornerRadius = 5.0
        Status.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
