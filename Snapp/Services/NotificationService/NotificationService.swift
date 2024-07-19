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
   func postNotification(title: String, body: String)
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
                completion(.success(isPermitted))
            }
        }
    }

    func postNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TestID", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
