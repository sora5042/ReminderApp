//
//  WashingViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/21.
//

import UIKit

class WashingViewController: UIViewController {
    
    weak var delegate: CategoryDelegate?
    
    private let cellId = "cellId"
    
    var washingArray = [
    
        "洗濯をする",
        "洗濯物を干す",
        "洗濯物を畳む",
        "アイロンがけ",
        "クリーニング",
    
        
    ]

    @IBOutlet weak var washingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        washingTableView.delegate = self
        washingTableView.dataSource = self
        washingTableView.register(UINib(nibName: "WashingTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)

    }

}

extension WashingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = washingTableView.dequeueReusableCell(withIdentifier: cellId) as! WashingTableViewCell
        cell.washingLabel.text = washingArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.category(category: washingArray[indexPath.row])
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
