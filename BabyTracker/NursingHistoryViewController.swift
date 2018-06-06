//
//  NursingHistoryViewController.swift
//  BabyTracker
//
//  Created by Justin Kim on 5/6/18.
//  Copyright © 2018 Justin Kim. All rights reserved.
//

import UIKit

class NursingHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nursingHistoryTableView: UITableView!
    
    var nursingHistory:[NursingHistory] = []
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        nursingHistoryTableView.dataSource = self
        nursingHistoryTableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        nursingHistory = NursingHistoryCoreDataHandler.fetchObject()!
        
        nursingHistoryTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nursingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let nursingHistoryCell = nursingHistory[indexPath.row]
        
        // date and time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: nursingHistoryCell.dateTime!)
        
        let stringDuration = String(format: "%.1f", nursingHistoryCell.duration)
        
        cell.textLabel?.text = "\(dateString), \t \(stringDuration) mins, \t \(nursingHistoryCell.amount!) oz, \t \(nursingHistoryCell.side!)"
        
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
