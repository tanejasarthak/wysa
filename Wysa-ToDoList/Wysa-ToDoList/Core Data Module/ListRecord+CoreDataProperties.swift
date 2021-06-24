//
//  ListRecord+CoreDataProperties.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//
//

import Foundation
import CoreData


extension ListRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListRecord> {
        return NSFetchRequest<ListRecord>(entityName: "ListRecord")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateAndTime: String?
    @NSManaged public var isRecordSelected: Bool

}

extension ListRecord : Identifiable {

}
