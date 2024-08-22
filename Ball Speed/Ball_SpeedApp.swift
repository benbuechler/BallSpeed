//
//  Ball_SpeedApp.swift
//  Ball Speed
//
//  Created by Ben Buechler on 2024-08-22.
//

import SwiftUI

@main
struct PitchSpeedReceiverApp: App {
    // This connects the AppDelegate to your SwiftUI app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
