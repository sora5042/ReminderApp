//
//  CookingTableViewCell.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/22.
//

import UIKit

class CookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cookingLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
