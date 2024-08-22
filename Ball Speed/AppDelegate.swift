//
//  AppDelegate.swift
//  Ball Speed
//
//  Created by Benjamin Buechler on 2024-08-28.
//


import UIKit
import WatchConnectivity

class AppDelegate: NSObject, UIApplicationDelegate, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the WCSession
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        return true
    }

    // Required method: Handles receiving files from Apple Watch
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsURL.appendingPathComponent(file.fileURL.lastPathComponent)

        do {
            try fileManager.moveItem(at: file.fileURL, to: destinationURL)
            print("File received and saved to \(destinationURL.path)")
        } catch {
            print("Error saving file: \(error)")
        }

        NotificationCenter.default.post(name: NSNotification.Name("FileReceived"), object: nil)
    }

    // Required method: Handles session becoming inactive
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive if needed
    }

    // Required method: Handles session deactivation and reactivation
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate() // Re-activate the session if needed
    }

    // Required method: Handles changes in the Watch state
    func sessionWatchStateDidChange(_ session: WCSession) {
        // Handle changes in the Watch state if needed
    }
}

