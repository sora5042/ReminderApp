//
//  HouseworkListViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/10.
//

import UIKit

class HouseworkListViewController: UIViewController {
    
    weak var delegate: HouseworkListTableViewCellDelegate?
    
    private let cellId = "cellId"
    private let helper = DatabaseHelper()
    var housework: Housework?
    var houseworks = [Housework]()
    
    var priority1 = [Housework]()
    var priority2 = [Housework]()
    var priority3 = [Housework]()
    var priority4 = [Housework]()
    
    let sectionTitle: NSArray = [
        "優先度: 最優先",
        "優先度: 高い",
        "優先度: 普通",
        "優先度: 低い"
        
    ]
    
    @IBOutlet weak var houseworkListTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchHouseworks()
        
    }
    
    private func setupView() {
        
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        houseworkListTableView.delegate = self
        houseworkListTableView.dataSource = self
        
        houseworkListTableView.register(UINib(nibName: "HouseworkListCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func fetchHouseworks() {
        
        helper.inDatabase { db in
            
            houseworks = try Housework.fetchAll(db)
            
            priority1 = try Housework.filter(sql: "priority == 1").fetchAll(db)
            priority2 = try Housework.filter(sql: "priority == 2").fetchAll(db)
            priority3 = try Housework.filter(sql: "priority == 3").fetchAll(db)
            priority4 = try Housework.filter(sql: "priority == 4").fetchAll(db)
            
        }
        
        houseworkListTableView.reloadData()
        
    }
    
    @objc private func tappedAddButton() {
        
        let houseworkViewController = UIStoryboard(name: "Housework", bundle: nil).instantiateViewController(withIdentifier: "HouseworkViewController") as! HouseworkViewController
        houseworkViewController.modalPresentationStyle = .fullScreen
        houseworkViewController.delegate = self
        self.present(houseworkViewController, animated: true, completion: nil)
    }
}

// MARK: - HouseworkListViewController: UITableViewDelegate, UITableViewDataSource
extension HouseworkListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return priority1.count
        case 1:
            return priority2.count
        case 2:
            return priority3.count
        case 3:
            return priority4.count
            
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = houseworkListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HouseListTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.housework = priority1[indexPath.row]
        case 1:
            cell.housework = priority2[indexPath.row]
        case 2:
            cell.housework = priority3[indexPath.row]
        case 3:
            cell.housework = priority4[indexPath.row]
        default:
            break
        }
        cell.houseworks = self.houseworks
        self.housework = cell.housework
        cell.delegate = self
        cell.alertDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let houseworkViewController = UIStoryboard(name: "Housework", bundle: nil).instantiateViewController(withIdentifier: "HouseworkViewController") as! HouseworkViewController
        helper.inDatabase { (db) in
            
            self.houseworks = try Housework.fetchAll(db)
            
            switch indexPath.section {
            case 0:
                houseworkViewController.housework = priority1[indexPath.row]
            case 1:
                houseworkViewController.housework = priority2[indexPath.row]
            case 2:
                houseworkViewController.housework = priority3[indexPath.row]
            case 3:
                houseworkViewController.housework = priority4[indexPath.row]
            default:
                break
            }
//            houseworkViewController.housework = self.houseworks[indexPath.row]
            houseworkViewController.modalPresentationStyle = .fullScreen
            self.present(houseworkViewController, animated: true, completion: nil)
        }
    }
}

extension HouseworkListViewController: HouseworkListTableViewCellDelegate {
    
    func notifiCell(houseworkFromCell: Housework) {
        
        helper.inDatabase { (db) in
            try houseworkFromCell.delete(db)
        }
        
        fetchHouseworks()
        houseworkListTableView.reloadData()
    }
}

extension HouseworkListViewController: HouseworkViewControllerDelegate {
    func housework(addHousework: Housework) {
        fetchHouseworks()
        
    }
}

