//
//  NursingHistoryCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/6/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class NursingHistoryCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(dateTime:Date, duration:Double, amount:String, side:String) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "NursingHistory", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(dateTime, forKey: "dateTime")
        manageObject.setValue(duration, forKey: "duration")
        manageObject.setValue(amount, forKey: "amount")
        manageObject.setValue(side, forKey: "side")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [NursingHistory]? {
        
        let context = getContext()
        var nursingHistory:[NursingHistory]? = nil
        
        do {
            nursingHistory = try context.fetch(NursingHistory.fetchRequest())
            return nursingHistory
        } catch {
            return nursingHistory
        }
    }
}
