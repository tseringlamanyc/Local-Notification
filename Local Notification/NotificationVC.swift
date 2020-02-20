//
//  ViewController.swift
//  Local Notification
//
//  Created by Tsering Lama on 2/20/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // data for table view
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var refreshControl: UIRefreshControl!
    
    private let center = UNUserNotificationCenter.current()
    
    private let pendingNotification = PendingNotifications()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getRefresh()
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
        center.delegate = self
        checkForAuthorization()
        loadNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nvc = segue.destination as? UINavigationController, let createVC = nvc.viewControllers.first as? CreateNotificationVC else {
            fatalError()
        }
        createVC.delegate = self
    }
    
    private func getRefresh() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        loadNotifications()
    }
    
    private func checkForAuthorization() {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized")
            } else {
                self.requestNotification()
            }
        }
    }
    
    private func requestNotification() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error requesting authorization: \(error)")
                return
            }
            if granted {
                print("granted")
            } else {
                print("denied")
            }
        }
    }
    
    @objc
    private func loadNotifications() {
        pendingNotification.getPendingNotifications { (request) in
            self.notifications = request
            // stop the refresh control
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let aNotification = notifications[indexPath.row]
        cell.textLabel?.text = aNotification.content.title
        cell.detailTextLabel?.text = aNotification.content.body
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // code for deletion here , delete pending notification
            removeNotification(indexPath: indexPath)
        }
    }
    
    private func removeNotification(indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        let identifier = notification.identifier
        // remove from UNNotificationCenter
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // remove from array of notification
        notifications.remove(at: indexPath.row)
        
        // remove from tableview
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension NotificationVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // foreground (in screen)
        completionHandler(.alert)
    }
}

extension NotificationVC: CreateNotificationDelegate {
    func didCreateNotification(createNotificationVC: CreateNotificationVC) {
        loadNotifications()
    }
}
