//
//  TrainzyApp.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-21.
//

import SwiftUI

@main
struct TrainzyApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
