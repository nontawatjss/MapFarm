//
//  WorkerCell.swift
//  FarmProject
//
//  Created by Nontawat on 9/3/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class WorkerCell: UITableViewCell {
    
    @IBOutlet weak var ImageCell: UIImageView!
    
    @IBOutlet weak var NameLine: UILabel!
    
    @IBOutlet weak var JobPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
