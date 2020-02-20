//
//  ViewController.swift
//  Local Notification
//
//  Created by Tsering Lama on 2/20/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // data for table view
    private var notifications = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self 
    }

}

extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        return cell
    }
    
    
}
