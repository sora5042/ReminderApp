//
//  CleanUpViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/21.
//

import UIKit

protocol CategoryDelegate: class {
    
    func category(category: String)
    
}

class CleanUpViewController: UIViewController {
    
    weak var delegate: CategoryDelegate?
    
    private let cellId = "cellId"
    
    var cleanUpArray = [
        
        "リビング",
        "トイレ掃除",
        "風呂掃除",
        "玄関を掃く",
        "廊下を掃除する"
    
    ]
    
    @IBOutlet weak var cleanUpTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cleanUpTableView.dataSource = self
        cleanUpTableView.delegate = self
        cleanUpTableView.register(UINib(nibName: "CleanUpTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)

       
    }

}

extension CleanUpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cleanUpTableView.dequeueReusableCell(withIdentifier: cellId) as! CleanUpTableViewCell
        
        cell.cleanUpLabel.text = cleanUpArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("delegate", delegate)
        delegate?.category(category: cleanUpArray[indexPath.row])
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
