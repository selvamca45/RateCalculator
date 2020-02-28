//
//  EstimateDataModal.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 14/10/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//

import UIKit

class EstimateDataModal: NSObject {
    var estimateId : Int = 0
    var estimateHours : Float = 0

    var estimateGB : Float = 0.0
    var estimateBillRate : Float = 0.0
    var miimumBillRate : Float = 0
    var estimatedTotalRevenue : Float = 0.0

    var miimumBillRateSalary : Float = 0.0
    var estimatedTotalRevenueSalary : Float = 0.0
    var maximumSalary : Float = 0.0

    var selectedFlag : Bool = false
    
    var region: String = ""
    var jobTitle : String = ""
    var jobLevel : String = ""
    
    var regionId: Int = 0
    var jobTitleId : Int = 0
    var jobLevelId : Int = 0
    var tableViewTextFlagArea : Bool = false
    var tableViewTextFlagJobTitle : Bool = false
    var tableViewTextFlagJobLevel : Bool = false
    
    var listOfAreaArray = NSMutableArray()
    var listOfJobTitleArray = NSMutableArray()
    var listOfJobLevelArray = NSMutableArray()


}
