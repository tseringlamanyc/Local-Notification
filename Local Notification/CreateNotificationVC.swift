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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        delegate?.didCreateNotification(createNotificationVC: self)
    }
}
