//
//  BreastFeedingCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/5/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class BreastFeedingCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(breastFeedingDate:Date, duration:Double, side:String) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "BreastFeedingTracker", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(breastFeedingDate, forKey: "breastFeedingDate")
        manageObject.setValue(duration, forKey: "duration")
        manageObject.setValue(side, forKey: "side")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [BreastFeedingTracker]? {
        
        let context = getContext()
        var breastFeedingTracker:[BreastFeedingTracker]? = nil
        
        do {
            breastFeedingTracker = try context.fetch(BreastFeedingTracker.fetchRequest())
            return breastFeedingTracker
        } catch {
            return breastFeedingTracker
        }
    }

}
