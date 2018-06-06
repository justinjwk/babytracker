//
//  DiaperCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/4/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class DiaperCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(diaperChangeTime:Date, type:String) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "DiaperTracker", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(diaperChangeTime, forKey: "diaperChangeTime")
        manageObject.setValue(type, forKey: "type")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [DiaperTracker]? {
        
        let context = getContext()
        var diaperTracker:[DiaperTracker]? = nil
        
        do {
            diaperTracker = try context.fetch(DiaperTracker.fetchRequest())
            return diaperTracker
        } catch {
            return diaperTracker
        }
        
    }
    
    
    
    
    
    
}

