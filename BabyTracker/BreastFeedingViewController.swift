//
//  BreastFeedingViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/5/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class BreastFeedingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // for left side
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var leftStartButton: UIButton!
    @IBOutlet weak var leftPauseButton: UIButton!
    @IBOutlet weak var leftSaveButton: UIButton!
    var leftDate = Date()
    var leftTimer = Timer()
    var leftCounter = 0.0
    var leftIsRunning = false
    var leftDuration = 0.0
    
    // for right side
    @IBOutlet weak var rightTimeLabel: UILabel!
    @IBOutlet weak var rightStartButton: UIButton!
    @IBOutlet weak var rightPauseButton: UIButton!
    @IBOutlet weak var rightSaveButton: UIButton!
    var rightDate = Date()
    var rightTimer = Timer()
    var rightCounter = 0.0
    var rightIsRunning = false
    var rightDuration = 0.0
    
    var whichSideIsRunning = ""
    
    // for CoreData
    var breastFeedingTracker:[BreastFeedingTracker]? = nil
    var nursingHistory:[NursingHistory]? = nil
    
    
    @IBOutlet weak var breastFeedingTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        leftTimeLabel.text = "\(leftCounter)"
        leftStartButton.isEnabled = true
        leftPauseButton.isEnabled = false
        leftSaveButton.isEnabled = false
        
        rightTimeLabel.text = "\(rightCounter)"
        rightStartButton.isEnabled = true
        rightPauseButton.isEnabled = false
        rightSaveButton.isEnabled = false
        
        breastFeedingTableView.dataSource = self
        breastFeedingTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        breastFeedingTracker = BreastFeedingCoreDataHandler.fetchObject()!
        
        breastFeedingTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftStartButtonClicked(_ sender: Any) {
        
        whichSideIsRunning = "L"
        leftSaveButton.isEnabled = true
        
        if !leftIsRunning {
            leftTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(BreastFeedingViewController.updateLeftTimer), userInfo: nil, repeats: true)
            
            leftStartButton.isEnabled = false
            leftPauseButton.isEnabled = true
            leftIsRunning = true
        }
        
    }
    
    @objc func updateLeftTimer() {
        
        leftCounter += 0.1
        leftTimeLabel.text = String(format: "%.1f", leftCounter)
    }
    
    @IBAction func leftPauseButtonClicked(_ sender: Any) {
        
        whichSideIsRunning = "L"
        
        leftStartButton.isEnabled = true
        leftPauseButton.isEnabled = false
        
        leftTimer.invalidate()
        leftIsRunning = false
        
    }
    
    @IBAction func leftSaveButtonClicked(_ sender: Any) {
        
        whichSideIsRunning = "L"
        
        leftTimer.invalidate()
        leftIsRunning = false
        leftDuration = leftCounter * 0.0166667
        
        leftDate = Date()
        
        // print for testing
        print("Testing: Date = \(leftDate.description), Duration = \(leftCounter) sec, Side = \(whichSideIsRunning)")
        
        // save data to CoreDat DB and print all list from DB
        if BreastFeedingCoreDataHandler.saveObject(breastFeedingDate: leftDate, duration: leftDuration, side: whichSideIsRunning) {
            
            breastFeedingTracker = BreastFeedingCoreDataHandler.fetchObject()
            
            for i in breastFeedingTracker! {
                print("\(i.breastFeedingDate!)" + ", " + "\(i.duration)" + ", " + "\(i.side!)")
            }
            print("\n")
        }
        breastFeedingTableView.reloadData()
        
        // save data to Nursing History CoreData DB and print all list
        if NursingHistoryCoreDataHandler.saveObject(dateTime: leftDate, duration: leftDuration, amount: "-", side: whichSideIsRunning) {
            
            nursingHistory = NursingHistoryCoreDataHandler.fetchObject()
            
            print("------ Nursing History ------\n")
            
            for i in nursingHistory! {
                print("\(i.dateTime!)" + ", " + "\(i.duration)" + ", " + "\(i.amount!)" + ", " + "\(i.side!)")
            }
            print("\n")
        }
        
        // reset Counter and Time Label
        leftCounter = 0
        leftTimeLabel.text = "\(leftCounter)"
        leftStartButton.isEnabled = true
        leftPauseButton.isEnabled = false
        whichSideIsRunning = ""
        leftSaveButton.isEnabled = false
    }
    
    @IBAction func rightStartButtonClicked(_ sender: Any) {
       
        whichSideIsRunning = "R"
        rightSaveButton.isEnabled = true
        
        if !rightIsRunning {
            rightTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(BreastFeedingViewController.updateRightTimer), userInfo: nil, repeats: true)
            
            rightStartButton.isEnabled = false
            rightPauseButton.isEnabled = true
            rightIsRunning = true
        }
        
    }
    
    @objc func updateRightTimer() {
        
        rightCounter += 0.1
        rightTimeLabel.text = String(format: "%.1f", rightCounter)
    }
    
    @IBAction func rightPauseButtonClicked(_ sender: Any) {
        
        whichSideIsRunning = "R"
        
        rightStartButton.isEnabled = true
        rightPauseButton.isEnabled = false
        
        rightTimer.invalidate()
        rightIsRunning = false
    }
    
    @IBAction func rightSaveButtonClicked(_ sender: Any) {
        
        whichSideIsRunning = "R"
        
        rightTimer.invalidate()
        rightIsRunning = false
        rightDuration = rightCounter * 0.0166667
        
        rightDate = Date()
        
        // print for testing
        print("Testing: Date = \(rightDate.description), Duration = \(rightCounter) sec, Side = \(whichSideIsRunning)")
        
        // save data to CoreDat DB and print all list from DB
        if BreastFeedingCoreDataHandler.saveObject(breastFeedingDate: rightDate, duration: rightDuration, side: whichSideIsRunning) {
            
            breastFeedingTracker = BreastFeedingCoreDataHandler.fetchObject()
            
            for i in breastFeedingTracker! {
                print("\(i.breastFeedingDate!)" + ", " + "\(i.duration)" + ", " + "\(i.side!)")
            }
            print("\n")
        }
        
        breastFeedingTableView.reloadData()
        
        // save data to Nursing History CoreData DB and print all list
        if NursingHistoryCoreDataHandler.saveObject(dateTime: rightDate, duration: rightDuration, amount: "-", side: whichSideIsRunning) {
            
            nursingHistory = NursingHistoryCoreDataHandler.fetchObject()
            
            print("------ Nursing History ------\n")
            
            for i in nursingHistory! {
                print("\(i.dateTime!)" + ", " + "\(i.duration)" + ", " + "\(i.amount!)" + ", " + "\(i.side!)")
            }
            print("\n")
        }
        
        // reset Counter and Time Label
        rightCounter = 0
        rightTimeLabel.text = "\(rightCounter)"
        rightStartButton.isEnabled = true
        rightPauseButton.isEnabled = false
        whichSideIsRunning = ""
        rightSaveButton.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breastFeedingTracker!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let breastFeedingCell = breastFeedingTracker![indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: breastFeedingCell.breastFeedingDate!)
        
        let stringDuration = String(format: "%.1f", breastFeedingCell.duration)
        
        cell.textLabel?.text = "\(dateString), \t\t \(stringDuration) mins, \t\t \(breastFeedingCell.side!)"
        
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
