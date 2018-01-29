//
//  NoteCellView.swift
//  AppSchool
//
//  Created by kwanso-ios on 1/26/18.
//  Copyright © 2018 Ahmad. All rights reserved.
//

import UIKit

class NoteCellView: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
