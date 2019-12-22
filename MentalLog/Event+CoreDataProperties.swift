//
//  Event+CoreDataProperties.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-21.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var stratUsed: String
    @NSManaged public var stratWorked: Bool
    @NSManaged public var text: String
    @NSManaged public var dateHappened: Date

}
