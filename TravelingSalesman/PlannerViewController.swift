//
//  PlannerViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit

class PlannerViewController: UITableViewController {

    var isPickerHidden = true
    var route: Route?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let route = route {
            datePickerView.date = route.date
        } else {
            datePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        
        updateDueDateLabel(date: datePickerView.date)
    }
    
    func updateDueDateLabel(date: Date) {
        dateLabel.text = Route.dateFormatter.string(from: date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [1,0]: //Date Cell
            return isPickerHidden ? normalCellHeight:
            largeCellHeight
            
        default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            
            dateLabel.textColor =
                isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: datePickerView.date)
    }

}
