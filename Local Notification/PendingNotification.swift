//
//  PendingNotification.swift
//  Local Notification
//
//  Created by Tsering Lama on 2/20/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotifications {
    public func getPendingNotifications(completionHandler: @escaping ([UNNotificationRequest])->()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("There are \(request.count) request")
            completionHandler(request)
        }
    }
}
