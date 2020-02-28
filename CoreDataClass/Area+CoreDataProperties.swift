//
//  Area+CoreDataProperties.swift
//  CiberRateCalculator
//
//  Created by Selvakumar on 05/11/19.
//  Copyright © 2019 Selvakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Area {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Area> {
        return NSFetchRequest<Area>(entityName: "Area")
    }

    @NSManaged public var areaId: String?
    @NSManaged public var areaName: String?
    @NSManaged public var cityString: String?

}
