//
//  DateCell.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 16-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Custom cell used in PlanRouteViewController to choose a date for a route.

import UIKit

class DateCell: UITableViewCell {
    
    var viewController: PlanRouteViewController?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = Route.dateFormatter.string(for: datePickerView.date)
        viewController?.date = dateLabel.text
    }
}
