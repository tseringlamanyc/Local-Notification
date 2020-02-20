//
//  CreateNotificationVC.swift
//  Local Notification
//
//  Created by Tsering Lama on 2/20/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

protocol CreateNotificationDelegate: AnyObject {
    func didCreateNotification(createNotificationVC: CreateNotificationVC)
}

class CreateNotificationVC: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: CreateNotificationDelegate?
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5 // current time plus 5 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func createLocalNotification() {
        // step 1: create the content
        let content = UNMutableNotificationContent()
        content.title = titleText.text ?? "No title"
        content.body = "Local Notification is awesome"
        content.subtitle = "Learning local notification"
        content.sound = .default
        
        // create identifier
        let identifier = UUID().uuidString
        
        // attachment
        if let imageURL = Bundle.main.url(forResource: "246007", withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print(error)
            }
        } else {
            print("no image found")
        }
        
        // create trigger ..... 3 of them (local, time, calender, location)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // create a request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotification Center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            } else {
                print("request was successfully added")
            }
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        // to avoid time in past
        guard sender.date > Date() else {return}
        // creates time stamp of the exact date
        timeInterval = sender.date.timeIntervalSinceNow
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        createLocalNotification()
        delegate?.didCreateNotification(createNotificationVC: self)
        dismiss(animated: true)
    }
}
