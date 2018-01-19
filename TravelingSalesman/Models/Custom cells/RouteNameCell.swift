//
//  RouteNameCell.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 18-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit

class RouteNameCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    public func configure(text: String?) {
        textField.text = text
        textField.accessibilityValue = text
    }
}
