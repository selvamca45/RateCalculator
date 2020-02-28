//
//  JobLevel+CoreDataProperties.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 06/11/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension JobLevel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobLevel> {
        return NSFetchRequest<JobLevel>(entityName: "JobLevel")
    }

    @NSManaged public var jobTitleID: String?
    @NSManaged public var roleID: String?
    @NSManaged public var roleName: String?

}
