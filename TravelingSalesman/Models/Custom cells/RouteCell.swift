//
//  RouteCell.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 22-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {

    @IBOutlet weak var routeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
