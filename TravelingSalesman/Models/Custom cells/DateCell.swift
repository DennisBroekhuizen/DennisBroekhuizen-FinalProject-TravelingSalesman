//
//  DateCell.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 16-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = Route.dateFormatter.string(for: datePickerView.date)
    }
    
}
