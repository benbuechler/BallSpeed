//
//  ContentView.swift
//  Ball Speed
//
//  Created by Ben Buechler on 2024-08-22.
//
import SwiftUI

struct ContentView: View {
    @State private var fileContent: String = "No data received yet."
    
    var body: some View {
        VStack {
            Text("Received Data:")
                .font(.headline)
            ScrollView {
                Text(fileContent)
                    .padding()
            }
            .onAppear(perform: loadFileContent)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FileReceived"))) { _ in
                loadFileContent()
            }
        }
        .padding()
    }
    
    func loadFileContent() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)

            if let latestFileURL = fileURLs.last {
                let content = try String(contentsOf: latestFileURL, encoding: .utf8)
                fileContent = content
            }
        } catch {
            print("Error loading file content: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
