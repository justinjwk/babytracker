//
//  HeightViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 3/31/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit
import AudioToolbox


class HeightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var heightPicker: UIPickerView!
    
    @IBOutlet weak var heightTableView: UITableView!
    
    var heightDate: Date? = nil
    var foot = 0.0
    var inch = 0.0
    var quaterInch = 0.0
    var totalHeight = 0.0
    
    // for CoreData
    var heightTracker:[HeightTracker]? = nil
    
    // variables for picker list
    let footList = Array(0...6)
    let inchList = Array(0...12)
    let quaterInchList = [".0", ".1/4", ".1/2", ".3/4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightPicker.delegate = self
        heightPicker.dataSource = self
        
        heightTableView.dataSource = self
        heightTableView.delegate = self
        
    }
    
    // display list to Table View
    override func viewWillAppear(_ animated: Bool) {
        
        heightTracker = HeightCoreDataHandler.fetchObject()!
        
        heightTableView.reloadData()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return footList.count
        } else if component == 1 {
            return inchList.count
        } else {
            return quaterInchList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return ("\(footList[row])" + " ft")
        } else if component == 1 {
            return ("\(inchList[row])")
        } else {
            return quaterInchList[row] + " inch"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            foot = Double(footList[row])
            print(foot)
        } else if component == 1 {
            inch = Double(inchList[row])
            print(inch)
            
        }
        else {
            if quaterInchList[row] == ".0" {
                quaterInch = 0.0
            } else if quaterInchList[row] == ".1/4" {
                quaterInch = 0.25
            } else if quaterInchList[row] == ".1/2" {
                quaterInch = 0.5
            } else {
                quaterInch = 0.75
            }
            print(quaterInch)
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // when user input height other than 0, then excute below code
        if !(foot == 0.0 && inch == 0.0 && quaterInch == 0.0) {
            
            datePicker.datePickerMode = .date
            heightDate = datePicker.date

            // for Date format
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let dateString = formatter.string(from: heightDate!)

            self.view.endEditing(true)

            // convert inch, quaterInch to feet and calculate the total feet
            totalHeight = foot + (inch * 0.0833333) + (quaterInch * 0.0833333)
            
            // print for testing
            print("Date = \(dateString)" + " / " + "Height(ft) = \(totalHeight)" )
            
            
            // print all list from CoreData DB
            if HeightCoreDataHandler.saveObject(heightDate: heightDate!, totalHeight: totalHeight) {
                
                heightTracker = HeightCoreDataHandler.fetchObject()
                
                for i in heightTracker! {
                    print("\(i.heightDate!)" + ", " + "\(i.totalHeight)")
                }
                print("\n")
            }
        }
        // when user input height as 0.0, then alert the user using animation!
        else {
            let alert = UIAlertController(title: "Wrong Input!", message: "Height cannot be zero!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print("Animation for error alert!")
        }
        
        heightTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return heightTracker!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let heightCell = heightTracker![indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: heightCell.heightDate!)
        
        cell.textLabel?.text = "\(dateString), \t\t \(heightCell.totalHeight) ft"
        
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
