//
//  JobTitle+CoreDataProperties.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 06/11/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension JobTitle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobTitle> {
        return NSFetchRequest<JobTitle>(entityName: "JobTitle")
    }

    @NSManaged public var jobTitleID: String?
    @NSManaged public var jobTitleName: String?

}
