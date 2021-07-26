//
//  CleanUpTableViewCell.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/22.
//

import UIKit

class CleanUpTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var cleanUpLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
