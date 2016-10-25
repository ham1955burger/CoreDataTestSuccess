//
//  Chat+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/25/16.
//  Copyright © 2016 ham. All rights reserved.
//

import Foundation
import CoreData

extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat");
    }

    @NSManaged public var isReceived: Bool
    @NSManaged public var message: String?
    @NSManaged public var sendDate: NSDate?
    @NSManaged public var sender: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var room: Room?

}
