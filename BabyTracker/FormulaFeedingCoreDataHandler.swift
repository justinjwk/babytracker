//
//  FormulaFeedingCoreDataHandler.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/5/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import CoreData

class FormulaFeedingCoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(formulaDate:Date, formulaAmount:Int, formulaDuration:Int) -> Bool {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "FormulaTracker", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(formulaDate, forKey: "formulaDate")
        manageObject.setValue(formulaAmount, forKey: "formulaAmount")
        manageObject.setValue(formulaDuration, forKey: "formulaDuration")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [FormulaTracker]? {
        
        let context = getContext()
        var formulaTracker:[FormulaTracker]? = nil
        
        do {
            formulaTracker = try context.fetch(FormulaTracker.fetchRequest())
            return formulaTracker
        } catch {
            return formulaTracker
        }
    }

}
