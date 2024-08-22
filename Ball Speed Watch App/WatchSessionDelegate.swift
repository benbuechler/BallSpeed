//
//  WatchSessionDelegate.swift
//  Ball Speed
//
//  Created by Benjamin Buechler on 2024-08-28.
//
import WatchConnectivity

class WatchSessionDelegate: NSObject, WCSessionDelegate {
    // Handle when the session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle errors if needed
    }

    // Handle incoming messages from the iPhone app
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle the message received from iPhone app (if needed)
    }
    
    // Handle file transfer
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        // Handle receiving files from iPhone (if needed)
    }
}
