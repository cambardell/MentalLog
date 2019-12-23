//
//  Strategy+CoreDataProperties.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-22.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//
//

import Foundation
import CoreData


extension Strategy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Strategy> {
        return NSFetchRequest<Strategy>(entityName: "Strategy")
    }

    @NSManaged public var totalUsed: Int16
    @NSManaged public var text: String
    @NSManaged public var worked: Int16

}
