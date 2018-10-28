//
//  StepsTableViewCell.swift
//  test_AliseumPodometeriOS
//
//  Created by Sloven Graciet on 27/10/2018.
//  Copyright © 2018 sloven Graciet. All rights reserved.
//

import UIKit
import SwiftDate

class StepsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func initialize(day: Date?, steps: String?, source: String?) {
        
        if let d = day {
            let hour  = Date().hour
            let d1 = d + hour.hours
            var dateString = d1.toRelative(style: RelativeFormatter.defaultStyle(), locale: nil)
            if dateString.contains("hour") {
                dateString = "Today"
            }
            self.dateLabel.text = dateString
        }
        self.sourceLabel.text = source
        self.stepsLabel.text = steps
    }

}
