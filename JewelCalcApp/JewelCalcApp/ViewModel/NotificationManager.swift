//
//  NotificationManager.swift
//  JewelCalcApp
//
//  Created by Hirpara, Nandan Ashvinbhai on 12/11/24.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func scheduleNotification(title: String, body: String, triggerDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

