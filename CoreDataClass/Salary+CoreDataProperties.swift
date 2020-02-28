//
//  Salary+CoreDataProperties.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 06/11/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Salary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Salary> {
        return NSFetchRequest<Salary>(entityName: "Salary")
    }

    @NSManaged public var areaID: String?
    @NSManaged public var averageSalary: String?
    @NSManaged public var jobTitleID: String?
    @NSManaged public var maxSalary: String?
    @NSManaged public var minSalary: String?
    @NSManaged public var roleID: String?

}
