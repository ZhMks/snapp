//
//  NotificationService.swift
//  Snapp
//
//  Created by Максим Жуин on 11.07.2024.
//

import Foundation
import UserNotifications


protocol NotificationManagerProtocol: AnyObject {
   func registerNotificationCenter(completion: @escaping (Result<Bool, Error>) -> Void)
   func postNotification()
}

class NotificationsService: NotificationManagerProtocol {

    let notificationCenter = UNUserNotificationCenter.current()

    static let shared = NotificationsService()

    private init() {}

    func registerNotificationCenter(completion: @escaping (Result<Bool, Error>) -> Void) {
        notificationCenter.requestAuthorization(options: [.badge, .alert]) { isPermitted, error in
            if let error = error {
                completion(.failure(error))
            }

            if isPermitted {
                print("Success")
                completion(.success(isPermitted))
            }
        }
    }

    func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Title for Notification"
        content.body = "Test Body For Notifications"
        content.sound = .default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TestID", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
