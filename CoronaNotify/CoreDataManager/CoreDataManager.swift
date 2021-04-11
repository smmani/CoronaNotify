//
//  CoreDataManager.swift
//  KFCNotify
//
//  Created by Selvakumar Murugan on 10/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    fileprivate func getContext() -> NSManagedObjectContext {
        let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
        return appDelegateObject.persistentContainer.viewContext
    }
    
    fileprivate func saveContext() {
        if getContext().hasChanges {
            do {
                try getContext().save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertEventLog(event : RegionEvent) {
        self.getContext().performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: "RegionLog", in: getContext())
            let log = NSManagedObject(entity: entity!, insertInto: getContext()) as! RegionLog
            log.latitude = event.latitude
            log.longitude = event.longitude
            log.eventType = event.eventType.rawValue
            log.identifier = event.identifier
            log.note = event.note
            log.logTime = event.eventTime
            self.saveContext()
        }
    }
    
    fileprivate func fetchRegionLogs() -> [RegionLog]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegionLog")
        request.returnsObjectsAsFaults = false
        do {
            let result = try getContext().fetch(request)
            if result.count > 0 {
                return (result as! [RegionLog])
          }
        } catch {
            print("Fetching logs failed....")
        }
        return nil
    }
    
    func fetchAllRegionEvents() -> [RegionEvent] {
        var eventList : [RegionEvent] = []
        if let logLists = fetchRegionLogs() {
            for log in logLists {
                let event = RegionEvent.init(from: log)
                eventList.append(event)
            }
        }
        return eventList
    }
}
