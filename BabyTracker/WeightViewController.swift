//
//  WeightViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 3/31/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    @IBOutlet weak var weightTableView: UITableView!
    
    var weightDate: Date? = nil
    var pound = 0.0
    var ounce = 0.0
    var totalWeight = 0.0
    
    var poundList = Array(0...200)
    var ounceList = Array(0...15)
    
    // for CoreData
    var weightTracker:[WeightTracker]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        weightTableView.dataSource = self
        weightTableView.delegate = self
        
    }
    
    // display list to Table View
    override func viewWillAppear(_ animated: Bool) {
        
        weightTracker = WeightCoreDataHandler.fetchObject()!
        
        weightTableView.reloadData()
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return poundList.count
        } else {
            return ounceList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return ("\(poundList[row])" + " lb")
        }
        return ("\(ounceList[row])" + " oz")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            pound = Double(poundList[row])
            print("Pound = \(pound)")           // print for testing
        } else {
            ounce = Double(ounceList[row])
            print("Ounce = \(ounce)")           // print for testing
        }
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // when user input height other than 0, then excute below code
        if !(pound == 0.0 && ounce == 0.0) {
            
            datePicker.datePickerMode = .date
            
            weightDate = datePicker.date
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let dateString = formatter.string(from: weightDate!)
            
            self.view.endEditing(true)
            
            // convert ounce to pound and calculate the total pound
            totalWeight = pound + (ounce * 0.0625)
            
            // print for testing
            print("Date = \(dateString)" + " / " + "Weight(lb) = \(totalWeight)")
            
            
            // print all list from CoreData DB
            if WeightCoreDataHandler.saveObject(weightDate: weightDate!, totalWeight: totalWeight) {
                
                weightTracker = WeightCoreDataHandler.fetchObject()
                
                for i in weightTracker! {
                    print("\(i.weightDate!)" + ", " + "\(i.totalWeight)")
                }
                print("\n")
            }
            
        }
        // when user input height as 0.0, then alert the user using animation!
        else {
            let alert = UIAlertController(title: "Wrong Input!", message: "Weight cannot be zero!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print("Animation for error alert!")
        }
        
        weightTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weightTracker!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let weightCell = weightTracker![indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: weightCell.weightDate!)
        
        cell.textLabel?.text = "\(dateString), \t\t \(weightCell.totalWeight) lb"
        
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
