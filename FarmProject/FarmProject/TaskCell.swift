//
//  TaskCell.swift
//  FarmProject
//
//  Created by Nontawat on 13/2/2562 BE.
//  Copyright © 2562 nontawat. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var BTDetail: UIButton!
    @IBOutlet weak var TDate: UILabel!
    @IBOutlet weak var TNo: UILabel!
    @IBOutlet weak var TName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
