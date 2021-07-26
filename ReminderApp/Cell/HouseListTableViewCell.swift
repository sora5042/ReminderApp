//
//  HouseListTableViewCell.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/10.
//

import UIKit

protocol HouseworkListTableViewCellDelegate: class {
    func notifiCell(houseworkFromCell: Housework)
    
}

class HouseListTableViewCell: UITableViewCell {
    
    weak var delegate: HouseworkListTableViewCellDelegate?
    var alertDelegate: HouseworkListViewController?
    
    let helper = DatabaseHelper()
    var houseworks = [Housework]()
    
    var housework: Housework? {
        didSet {
            
            houseworkLabel.text = housework?.housework
            commentLabel.text = housework?.comment
            dateLabel.text = housework?.date
        }
    }
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var houseworkLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationLabel.text = "通知日時"
        clearButton.addTarget(self, action: #selector(tappedClearButton), for: .touchUpInside)
        
    }
    
    @objc func tappedClearButton() {
        
        let alert = UIAlertController(title: "アラート表示", message: "本当に削除しても良いですか？", preferredStyle: UIAlertController.Style.alert)
        let clearAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            
            self.delegate?.notifiCell(houseworkFromCell: self.housework!)
            
        }
        
        alert.addAction(clearAction)
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alertDelegate?.present(alert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


