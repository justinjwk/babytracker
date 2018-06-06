//
//  HeightCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/4/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class HeightCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(heightDate:Date, totalHeight:Double) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "HeightTracker", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(heightDate, forKey: "heightDate")
        manageObject.setValue(totalHeight, forKey: "totalHeight")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [HeightTracker]? {
    
        let context = getContext()
        var heightTracker:[HeightTracker]? = nil
        
        do {
            heightTracker = try context.fetch(HeightTracker.fetchRequest())
            return heightTracker
        } catch {
            return heightTracker
        }
        
    }

    
    
    
    
    
}
