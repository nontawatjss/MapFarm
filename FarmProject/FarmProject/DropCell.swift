//
//  DropCell.swift
//  FarmProject
//
//  Created by Nontawat on 14/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class DropCell: UITableViewCell {

    @IBOutlet weak var ImgName: UIImageView!
    @IBOutlet weak var FName: UILabel!
    @IBOutlet weak var LastName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
