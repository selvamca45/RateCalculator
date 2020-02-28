//
//  EstimateTableViewCell.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 14/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit

class EstimateTableViewCell: UITableViewCell,UITextFieldDelegate {

    
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var jobTitleButton: UIButton!
    @IBOutlet weak var jobTitleLabel: UILabel!

    @IBOutlet weak var jobLevelButton: UIButton!
    @IBOutlet weak var GPValueTextField: UITextField!
    @IBOutlet weak var minimumBillRateTextField: UITextField!
    @IBOutlet weak var extimatedHoursTextField: UITextField!
    @IBOutlet weak var cellView : UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var resourceCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        GPValueTextField.delegate = self
        minimumBillRateTextField.delegate = self
        minimumBillRateTextField.delegate = self

//        cellView.layer.cornerRadius = 20.0
//        cellView.layer.shadowColor = UIColor.gray.cgColor
//        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        cellView.layer.shadowRadius = 12.0
//        cellView.layer.shadowOpacity = 0.7
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func setCell(name:String){
//        self.nameInput.placeholder = name
//    }
    
    
}
