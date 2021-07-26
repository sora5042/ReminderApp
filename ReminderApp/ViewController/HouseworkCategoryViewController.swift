//
//  HouseworkCategoryViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/21.
//

import UIKit
import Parchment

protocol HoouseworkCategoryDelegate: class {
    
    func passCategory(category: String)
}

class HouseworkCategoryViewController: UIViewController {
    
    weak var delegate: HoouseworkCategoryDelegate?
    
    let cleanUpViewController = UIStoryboard(name: "CleanUp", bundle: nil).instantiateViewController(withIdentifier: "CleanUpViewController") as! CleanUpViewController
    let cookingViewController = UIStoryboard(name: "Cooking", bundle: nil).instantiateViewController(withIdentifier: "CookingViewController") as! CookingViewController
    let washingViewController = UIStoryboard(name: "Washing", bundle: nil).instantiateViewController(withIdentifier: "WashingViewController") as! WashingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPagingViewController()
        
    }
    
    private func initPagingViewController() {
        
        
        cleanUpViewController.delegate = self
        cookingViewController.delegate = self
        washingViewController.delegate = self
        cleanUpViewController.title = "掃除"
        cookingViewController.title = "料理"
        washingViewController.title = "洗濯"
        
        let pagingVC = PagingViewController(viewControllers: [cleanUpViewController, cookingViewController, washingViewController])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        pagingVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pagingVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pagingVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pagingVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
        
        pagingVC.selectedBackgroundColor = .clear
        pagingVC.indicatorColor = .brown
        pagingVC.textColor = .lightGray
        pagingVC.selectedTextColor = .black
        pagingVC.menuBackgroundColor = .clear
        pagingVC.borderColor = .clear
        
        //        pagingVC.dataSource = self
        
        
    }
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension HouseworkCategoryViewController: CategoryDelegate {
    func category(category: String) {
        
        delegate?.passCategory(category: category)
        
    }
}
