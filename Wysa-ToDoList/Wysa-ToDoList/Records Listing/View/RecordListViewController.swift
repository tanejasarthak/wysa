//
//  RecordListViewController.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//

import UIKit
import UserNotifications

class RecordListViewController: UIViewController {

    // MARK: - IBOultets
    @IBOutlet weak var recordListingTableView: UITableView!
    
    // Public Properies
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listOfRecords = [ListRecord]()
    let dateFormatter = DateFormatter()
    var viewModel = RecordListViewModel()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manageTableView()
       // fetchStoredData()
        viewModel.fetchStoredData(context: context)
        setupNotification()
        reloadTableView()
        checkForExpiredRecords()
    }
    
    func setupNotification() {
        notificationCenter.delegate =  self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
        }
    }
    
    func checkForExpiredRecords() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for record in viewModel.listOfRecords where record.isRecordSelected == false {
            if dateFormatter.date(from: record.dateAndTime!) ?? Date() < Date() {
                triggerNotification(title: record.name ?? "")
            }
        }
    }
    
    func triggerNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category"
        content.badge = 1
        content.title = title
        content.body = "Your task is pending for now."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let identifier = "Action Identifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print("\(String(describing: error?.localizedDescription))")
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.recordListingTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView()
    }

    func manageTableView() {
        recordListingTableView.delegate = self
        recordListingTableView.dataSource =  self
        recordListingTableView.tableFooterView = UIView()
        recordListingTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
    }
    
    // MARK: - IBActions
    @IBAction func addNewRecord() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddRecordsViewController") as! AddRecordsViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate and Datasource
extension RecordListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listOfRecords.count
      //  return listOfRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell
    //    cell?.configureCell(record: listOfRecords[indexPath.row])
        cell?.configureCell(record: viewModel.listOfRecords[indexPath.row])
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, _) in
           // self.deleteRecord(record: self.listOfRecords[indexPath.row])
            self.viewModel.deleteRecord(record: self.viewModel.listOfRecords[indexPath.row], context: self.context)
            self.reloadTableView()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Checkbox Tap Delegate
extension RecordListViewController: CheckBoxTap {
    func checkBoxTapped(isSelected: Bool, item: ListRecord) {
        item.isRecordSelected = isSelected
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Core Data Functions
extension RecordListViewController: AddDateToCore {
    func addData(title: String, dateTime: Date) {
        viewModel.addData(title: title, dateTime: dateTime, context: context)
        reloadTableView()
    }
}

// MARK: - UNUser NotificationCenter Delegate {
extension RecordListViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner ,.badge, .sound])
    }
}
