//
//  ViewController.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/09.
//

import UIKit
import GRDB

protocol HouseworkViewControllerDelegate: class {
    
    func housework(addHousework: Housework)
}

enum repeatType {
    case day
    case week
    case month
    case year
}

class HouseworkViewController: UIViewController {
    
    weak var delegate: HouseworkViewControllerDelegate?
    
    let helper = DatabaseHelper()
    var housework: Housework?
    var houseworks = [Housework]()
    let houseListTableViewCell = HouseListTableViewCell()
    var cleanUpViewController = CleanUpViewController()
    
    var repeatNumber = Int()
    var priorityNumber = Int(1)
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dayNumberTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var houseworkTextField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var commentTextFeild: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberCountStepper: UIStepper!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
        self.view.sendSubviewToBack(drawView)
        
        nameLabel.layer.borderWidth = 0.7
        nameLabel.layer.cornerRadius = 19.5
        categoryButton.layer.borderWidth = 1.5
        categoryButton.layer.borderColor = UIColor.systemOrange.cgColor
        categoryButton.layer.cornerRadius = 11
        houseListTableViewCell.delegate = self
        houseworkTextField.text = housework?.housework
        commentTextFeild.text = housework?.comment
        dateLabel.text = housework?.date
        
        dayNumberTextField.keyboardType = .numberPad
        
        saveButton.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
        dateDoneButton.addTarget(self, action: #selector(tappedDateDoneButton), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(tappedCategoryButton), for: .touchUpInside)
        
    }
    
    @objc private func tappedCategoryButton() {
        
        let houseworkCategoryViewController = UIStoryboard(name: "HouseworkCategory", bundle: nil).instantiateViewController(withIdentifier: "HouseworkCategoryViewController") as! HouseworkCategoryViewController
        houseworkCategoryViewController.delegate = self
        houseworkCategoryViewController.modalPresentationStyle = .fullScreen
        
        self.present(houseworkCategoryViewController, animated: true, completion: nil)
        
    }
    
    @objc private func tappedDateDoneButton() {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        
        dateLabel.text = "\(format.string(from: datePicker.date))"
    }
    
    @objc private func tappedSaveButton() {
        
        if housework == nil {
            
            
            localNotification()
            
        } else {
            
            updateLocalNotification()
            
        }
        
        delegate?.housework(addHousework: housework!)
        dismiss(animated: true, completion: nil)
    }
    
    
    private func localNotification() {
        
        guard let houseworkText = houseworkTextField.text else { return }
        guard let commentText = commentTextFeild.text else { return }
        
        // MARK: 通知の中身を設定
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = "\(houseworkText)の時間です！"
        content.subtitle = commentText
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // MARK: 通知をいつ発動するかを設定
        // カレンダークラスを作成
        let calendar = Calendar.current
        let calendarComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: true)
        
        // MARK: 通知のリクエストを作成
        let id = UUID().uuidString
        let request: UNNotificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        print("notificationId", id)
        createHouseworkData(id: id)
        
        
        //                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        //
        //                    requests.forEach { request in
        //                      let id = request.identifier
        //
        //                        self.createHouseworkData(id: id)
        //                        print("id", request.identifier)
        //                    }
        //                }
        
        // MARK: 通知のリクエストを実際に登録する
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            
            if error != nil {
                
            } else {
                
            }
        }
    }
    
    private func updateLocalNotification() {
        
        guard let notificationid = housework?.notificationId else { return }
        guard let houseworkText = houseworkTextField.text else { return }
        guard let commentText = commentTextFeild.text else { return }
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationid])
        
        // MARK: 通知の中身を設定
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = "\(houseworkText)の時間です！"
        content.subtitle = commentText
        content.sound = UNNotificationSound.default
        content.badge = 1
        // MARK: 通知をいつ発動するかを設定
        // カレンダークラスを作成
        let calendar: Calendar = Calendar.current
        let trigger: UNCalendarNotificationTrigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date), repeats: true)
        
        // MARK: 通知のリクエストを作成
        let newId = UUID().uuidString
        let request: UNNotificationRequest = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
        print("newId", notificationid)
        updateHouseworkData(notificationId: notificationid)
        // MARK: 通知のリクエストを実際に登録する
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            
            if error != nil {
                
            } else {
                
            }
        }
    }
    
    private func updateHouseworkData(notificationId: String) {
        
        helper.inDatabase{(db) in
            do {
                guard let houseworkText = houseworkTextField.text else { return }
                guard let commentText = commentTextFeild.text else { return }
                guard let date = dateLabel.text else { return }
                
                housework?.notificationId = notificationId
                housework?.housework = houseworkText
                housework?.comment = commentText
                housework?.date = date
                try housework?.update(db)
            } catch let error {
                print("error", error)
                
            }
            
            let houseworks = try (Housework.fetchAll(db) as? [Housework])
            self.houseworks = houseworks!
            
            houseworks?.forEach({ (housework) in
                
            })
        }
    }
    
    private func createHouseworkData(id: String) {
        
        let result = helper.inDatabase{(db) in
            do {
                guard let houseworkText = houseworkTextField.text else { return }
                guard let commentText = commentTextFeild.text else { return }
                guard let date = dateLabel.text else { return }
                
                housework = Housework(notificationId: id, housework: houseworkText, date: date, createdAt: Date().timeIntervalSince1970, repeatDay: repeatNumber, comment: commentText, priority: priorityNumber)
                try housework?.insert(db)
            } catch let error {
                print("error", error)
                
            }
            
            let houseworks = try (Housework.fetchAll(db) as? [Housework])
            self.houseworks = houseworks!
            houseworks?.forEach({ (housework) in
                
            })
        }
        if (!result) {
            
        } else {
        }
    }
    
    private func repeatNotification() {
        
        guard let houseworkText = houseworkTextField.text else { return }
        guard let commentText = commentTextFeild.text else { return }
        
        // MARK: 通知の中身を設定
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = "\(houseworkText)の時間です！"
        content.subtitle = commentText
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        switch repeatNumber {
        case 0:
            let calendar = Calendar.current
            let calendarComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: true)
            let id = UUID().uuidString
            let request: UNNotificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error: Error?) in
                
                if error != nil {
                    
                } else {
                    
                }
            }
        //        case 1:
        //            var dateComponentsDay = DateComponents()
        //            dateComponentsDay.
        //            dateComponentsDay.calendar?.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
        //            let id = UUID().uuidString
        //            let request: UNNotificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        //            // MARK: 通知のリクエストを実際に登録する
        //            UNUserNotificationCenter.current().add(request) { (error: Error?) in
        //
        //                if error != nil {
        //
        //                } else {
        //
        //                }
        //            }
        //        case 2:
        //            var dateComponentsDay = DateComponents()
        //            dateComponentsDay.weekOfYear = 1
        //            dateComponentsDay.calendar?.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
        //            let id = UUID().uuidString
        //            let request: UNNotificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        //            // MARK: 通知のリクエストを実際に登録する
        //            UNUserNotificationCenter.current().add(request) { (error: Error?) in
        //
        //                if error != nil {
        //
        //                } else {
        //
        //                }
        //            }
        //        case 3:
        //            <#code#>
        default:
            break
        }
        
        // MARK: 通知をいつ発動するかを設定
        // カレンダークラスを作成
        let calendar = Calendar.current
        let calendarComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarComponents, repeats: false)
        
        // MARK: 通知のリクエストを作成
        let id = UUID().uuidString
        let request: UNNotificationRequest = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        print("notificationId", id)
        createHouseworkData(id: id)
        
        // MARK: 通知のリクエストを実際に登録する
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            
            if error != nil {
                
            } else {
                
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dayNumberCountStepper(_ sender: UIStepper) {
        
        dayNumberTextField.text = "\(sender.value)"
    }
    
    @IBAction func repeatSegmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            repeatLabel.text = "日ごと"
            repeatNumber = 0
        case 1:
            repeatLabel.text = "週間ごと"
            repeatNumber = 1
        case 2:
            repeatLabel.text = "ヶ月ごと"
            repeatNumber = 2
        case 3:
            repeatLabel.text = "年ごと"
            repeatNumber = 3
        default: break
            
        }
    }
    
    @IBAction func prioritySegmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            priorityLabel.text = "最優先"
            priorityNumber = 1
        case 1:
            priorityLabel.text = "高い"
            priorityNumber = 2
        case 2:
            priorityLabel.text = "普通"
            priorityNumber = 3
        case 3:
            priorityLabel.text = "低い"
            priorityNumber = 4
        default: break
            
        }
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
}

extension HouseworkViewController: HouseworkListTableViewCellDelegate {
    func notifiCell(houseworkFromCell: Housework) {
        
        helper.inDatabase { (db) in
            
            self.houseworks = try Housework.fetchAll(db)
            
        }
    }
}

extension HouseworkViewController: HoouseworkCategoryDelegate {
    func passCategory(category: String) {
        
        houseworkTextField.text = category
    }
}


// MARK: - DrawView
class DrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 20, y: 360))
        line.addLine(to:CGPoint(x: 350, y: 360))
        line.close()
        UIColor.gray.setStroke()
        line.lineWidth = 2.0
        line.stroke()
        line.lineCapStyle = .round
        
    }
}
