//
//  FormulaFeedingViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/5/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class FormulaFeedingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var amountDurationPicker: UIPickerView!
    
    @IBOutlet weak var formulaFeedingTableView: UITableView!
    
    var formulaDate: Date? = nil
    var amount = 1
    var duration = 1
    
    var amountList = Array(1...20)
    var durationList = Array(1...60)
    
    // for CoreData
    var formulaTracker:[FormulaTracker]? = nil
    var nursingHistory:[NursingHistory]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountDurationPicker.delegate = self
        amountDurationPicker.dataSource = self
        
        formulaFeedingTableView.dataSource = self
        formulaFeedingTableView.delegate = self
    }
    
    // display list to Table View
    override func viewWillAppear(_ animated: Bool) {
        
        formulaTracker = FormulaFeedingCoreDataHandler.fetchObject()!
        
        formulaFeedingTableView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return amountList.count
        } else {
            return durationList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return ("\(amountList[row])" + " oz")
        } else {
            return ("\(durationList[row])" + " min")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            amount = amountList[row]
            print("Testing: Amount = \(amount)")         // print for testing
        } else {
            duration = durationList[row]
            print("Testing: Duration = \(duration)")     // print for testing
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        
        datePicker.datePickerMode = .dateAndTime
        
        formulaDate = datePicker.date
        
        print("Testing: Date/Time = \(formulaDate!.description)")     // print for testing
        
        // save data to CoreData DB and print all list from CoreData DB
        if FormulaFeedingCoreDataHandler.saveObject(formulaDate: formulaDate!, formulaAmount: amount, formulaDuration: duration) {
            
            formulaTracker = FormulaFeedingCoreDataHandler.fetchObject()
            
            for i in formulaTracker! {
                print("\(i.formulaDate!)" + ", " + "\(i.formulaAmount)" + ", " + "\(i.formulaDuration)")
            }
            print("\n")
        }
    
        // save data to Nursing History CoreData DB and print all list
        if NursingHistoryCoreDataHandler.saveObject(dateTime: formulaDate!, duration: Double(duration), amount: String(amount), side: "F") {
            
            nursingHistory = NursingHistoryCoreDataHandler.fetchObject()
        
            print("------ Nursing History ------\n")
        
            for i in nursingHistory! {
                print("\(i.dateTime!)" + ", " + "\(i.duration)" + ", " + "\(i.amount!)" + ", " + "\(i.side!)")
            }
            print("\n")
        }
        
        formulaFeedingTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return formulaTracker!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let formulaFeedingCell = formulaTracker![indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: formulaFeedingCell.formulaDate!)
        
        let stringDuration = String(format: "%.1f", Double(formulaFeedingCell.formulaDuration))
        
        cell.textLabel?.text = "\(dateString), \t\t \(formulaFeedingCell.formulaAmount) oz, \t\t \(stringDuration) mins"
        
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
