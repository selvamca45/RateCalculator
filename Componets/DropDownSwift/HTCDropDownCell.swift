//
//  HTCDropDownCell.swift
//  DropDownController
//
//  Created by Vishnu on 23/05/17.
//  Copyright © 2017 Vishnu. All rights reserved.
//

import UIKit

class HTCDropDownCell: UITableViewCell {

    @IBOutlet weak var selectionView: UIView!
    
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var singleSelectionLabel: UILabel!
    @IBOutlet weak var cellOverVeiw : UIView!
    @IBOutlet weak var deletButton : UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected
        {
             deletButton.setImage(UIImage(named: "Check-selected"), for: .normal)
        }
        else
        {
            deletButton.setImage(UIImage(named: "Check_Default"), for: .normal)

        }
        // Configure the view for the selected state
    }
    
}
