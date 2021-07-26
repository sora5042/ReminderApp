//
//  CookingViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/21.
//

import UIKit

class CookingViewController: UIViewController {
    
    weak var delegate: CategoryDelegate?
    
    private let cellId = "cellId"
    
    var cookingArray = [
        
        "朝ごはんを作る",
        "昼ごはんを作る",
        "晩ごはんを作る",
        "ごはんを炊く",
        "お弁当を作る",
    
    ]

    @IBOutlet weak var cookingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cookingTableView.delegate = self
        cookingTableView.dataSource = self
        cookingTableView.register(UINib(nibName: "CookingTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

}

extension CookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cookingTableView.dequeueReusableCell(withIdentifier: cellId) as! CookingTableViewCell
        
        cell.cookingLabel.text = cookingArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.category(category: cookingArray[indexPath.row])
        dismiss(animated: true, completion: nil)
        
    }
}
