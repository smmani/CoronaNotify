//
//  RegionLog+CoreDataProperties.swift
//  CoronaNotify
//
//  Created by Selvakumar Murugan on 11/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//
//

import Foundation
import CoreData


extension RegionLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegionLog> {
        return NSFetchRequest<RegionLog>(entityName: "RegionLog")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var radius: Double
    @NSManaged public var identifier: String?
    @NSManaged public var note: String?
    @NSManaged public var eventType: Int64

}
