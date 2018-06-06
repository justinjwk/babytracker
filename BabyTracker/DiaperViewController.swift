//
//  DiaperViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 4/28/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class DiaperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var diaperChangeTime: Date? = nil
    var type = ""
    
    // for CoreData
    var diaperTracker:[DiaperTracker]? = nil
    
    @IBOutlet weak var diaperChangeTimePicker: UIDatePicker!
    @IBOutlet weak var diaperChangeTypeSelect: UISegmentedControl!
    
    @IBOutlet weak var diaperTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaperTableView.dataSource = self
        diaperTableView.delegate = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaperTracker = DiaperCoreDataHandler.fetchObject()!
        
        diaperTableView.reloadData()
    }
    
    @IBAction func diaperChangeTypeSelected(_ sender: Any) {
        
        switch diaperChangeTypeSelect.selectedSegmentIndex {
        case 0:
            type = "Wet"
        case 1:
            type = "Dirty"
        case 2:
            type = "Both"
        case 3:
            type = "Dry"
        default:
            break
        }
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        diaperChangeTimePicker.datePickerMode = .dateAndTime
        
        diaperChangeTime = diaperChangeTimePicker.date
        
        diaperChangeTypeSelected(diaperChangeTypeSelect)
        
        // print for testing
        //print("\(diaperChangeTime!)" + ", " + "\(type)")
        
        // print all list from CoreData DB
        if DiaperCoreDataHandler.saveObject(diaperChangeTime: diaperChangeTime!, type: type) {
         
            diaperTracker = DiaperCoreDataHandler.fetchObject()
            
            for i in diaperTracker! {
                print("\(i.diaperChangeTime!)" + ", " + "\(i.type!)")
                
            }
            print("\n")
        }
        
        diaperTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diaperTracker!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let diaperCell = diaperTracker![indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: diaperCell.diaperChangeTime!)
        
        
        cell.textLabel?.text = "\(dateString), \t\t\t \(diaperCell.type!)"
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
