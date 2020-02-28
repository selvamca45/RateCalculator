//
//  Rate+CoreDataProperties.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 06/11/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var areaID: String?
    @NSManaged public var averageRate: String?
    @NSManaged public var jobTitleID: String?
    @NSManaged public var maxRate: String?
    @NSManaged public var minRate: String?
    @NSManaged public var roleID: String?

}
