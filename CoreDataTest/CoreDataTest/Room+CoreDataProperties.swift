//
//  Room+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/17/16.
//  Copyright © 2016 ham. All rights reserved.
//

import Foundation
import CoreData

extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room");
    }

    @NSManaged public var name: String?
    @NSManaged public var chat: NSOrderedSet?

}

// MARK: Generated accessors for chat
extension Room {

    @objc(insertObject:inChatAtIndex:)
    @NSManaged public func insertIntoChat(_ value: Chat, at idx: Int)

    @objc(removeObjectFromChatAtIndex:)
    @NSManaged public func removeFromChat(at idx: Int)

    @objc(insertChat:atIndexes:)
    @NSManaged public func insertIntoChat(_ values: [Chat], at indexes: NSIndexSet)

    @objc(removeChatAtIndexes:)
    @NSManaged public func removeFromChat(at indexes: NSIndexSet)

    @objc(replaceObjectInChatAtIndex:withObject:)
    @NSManaged public func replaceChat(at idx: Int, with value: Chat)

    @objc(replaceChatAtIndexes:withChat:)
    @NSManaged public func replaceChat(at indexes: NSIndexSet, with values: [Chat])

    @objc(addChatObject:)
    @NSManaged public func addToChat(_ value: Chat)

    @objc(removeChatObject:)
    @NSManaged public func removeFromChat(_ value: Chat)

    @objc(addChat:)
    @NSManaged public func addToChat(_ values: NSOrderedSet)

    @objc(removeChat:)
    @NSManaged public func removeFromChat(_ values: NSOrderedSet)

}
