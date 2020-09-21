//
//  StepCell.swift
//  TimeForRepeat
//
//  Created by shiryaev-da on 16.09.2020.
//  Copyright © 2020 shiryaev-da. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTimeCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // label.textColor = UIColor.green
        // Configure the view for the selected state
    }
    
}
