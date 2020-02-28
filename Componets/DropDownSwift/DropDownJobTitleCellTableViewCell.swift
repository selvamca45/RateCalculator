//
//  DropDownJobTitleCellTableViewCell.swift
//  CiberRateCalculator
//
//  Created by aneesf on 23/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit

class DropDownJobTitleCellTableViewCell: UITableViewCell {
    @IBOutlet weak var singleSelectionLabel: UILabel!
    @IBOutlet weak var checkButton : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected
        {
            checkButton.isHidden = false
            checkButton.setImage(UIImage(named: "Check-selected"), for: .normal)
        }
        else
        {
            checkButton.setImage(UIImage(named: "Check_Default"), for: .normal)
            checkButton.isHidden = true
            
        }
    }
    
}
