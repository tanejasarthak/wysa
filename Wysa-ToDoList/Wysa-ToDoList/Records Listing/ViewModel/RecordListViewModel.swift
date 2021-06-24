//
//  RecordListViewModel.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//

import Foundation
import CoreData

struct RecordListViewModel {
    
    let dateFormatter = DateFormatter()
    var listOfRecords = [ListRecord]()
    
    mutating func addData(title: String, dateTime: Date, context: NSManagedObjectContext) {
        let newItem = ListRecord(context: context)
        newItem.name = title
        dateFormatter.dateFormat = "yyyy-MM-dd hh:MM:ss"
        newItem.dateAndTime = dateFormatter.string(from: dateTime)
        
        do {
            try context.save()
            listOfRecords = try context.fetch(ListRecord.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func fetchStoredData(context: NSManagedObjectContext) {
        do {
            listOfRecords = try context.fetch(ListRecord.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func deleteRecord(record: ListRecord, context: NSManagedObjectContext) {
        context.delete(record)
        do {
            try context.save()
            listOfRecords = try context.fetch(ListRecord.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    init() {
        
    }
}
