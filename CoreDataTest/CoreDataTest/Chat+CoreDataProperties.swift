//
//  Chat+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/17/16.
//  Copyright © 2016 ham. All rights reserved.
//

import Foundation
import CoreData

extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat");
    }

    @NSManaged public var sender: Int16
    @NSManaged public var isReceived: Bool
    @NSManaged public var message: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var room: Room?

}
