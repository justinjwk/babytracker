//
//  WeightCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/4/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class WeightCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(weightDate:Date, totalWeight:Double) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WeightTracker", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(weightDate, forKey: "weightDate")
        manageObject.setValue(totalWeight, forKey: "totalWeight")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    class func fetchObject() -> [WeightTracker]? {

        let context = getContext()
        var weightTracker:[WeightTracker]? = nil

        do {
            weightTracker = try context.fetch(WeightTracker.fetchRequest())
            return weightTracker
        } catch {
            return weightTracker
        }

    }
}

