import SwiftUI // imports the swiftui elements
import CoreMotion // imports functions for
import WatchConnectivity // imports functions for connecting to the phone

struct ContentView: View {
    // State variables to manage UI and logic states
    @State private var pitchSpeed: String = "--" // Holds the current pitch speed to display
    @State private var isSessionActive: Bool = false // Tracks if the data logging session is active
    @State private var logFileURL: URL? = nil // Holds the URL of the log file where data is stored
    @State private var session: WCSession = WCSession.default
    // CoreMotion manager to access motion data from the Apple Watch sensors
    private let motionManager = CMMotionManager()
    
    init() {
        if WCSession.isSupported() {
                self.session = WCSession.default
                self.session.delegate = WatchSessionDelegate()
                self.session.activate()
            } else {
                self.session = WCSession.default
        }
    }
    
    

    var body: some View {
        // The main UI layout of the Apple Watch app
        VStack {
            Text("Pitch Speed")
                .font(.headline) // Sets the font style for the "Pitch Speed" label
            Text("\(pitchSpeed) mph")
                .font(.largeTitle) // Sets the font style for the pitch speed value
                .padding() // Adds padding around the text
                

            // Conditional rendering of buttons based on session state
            if isSessionActive {
                Button(action: stopSession) { // If session is active, show "Stop Session" button
                    Text("Stop Session")
                }
                .background(Color.red)
                .cornerRadius(30)
                
            } else {
                Button(action: startSession) { // If session is inactive, show "Start Session" button
                    Text("Start Session")
                }
                .background(Color.green)
                .cornerRadius(30)
            }
        }
        .onAppear {
            // When the view appears, set up the log file
            self.setupLogFile()
        }
    }

    // Sets up the log file where motion data will be stored
    func setupLogFile() {
        let fileManager = FileManager.default // Access the default file manager
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Get the document directory URL
            let logFileName = "motionDataLog.txt" // Name of the log file
            DispatchQueue.main.async {
                // Ensure this runs on the main thread to allow mutating self
                self.logFileURL = documentDirectory.appendingPathComponent(logFileName)
                // Create the log file if it doesn't exist
                fileManager.createFile(atPath: self.logFileURL!.path, contents: nil, attributes: nil)
            }
        }
    }

    // Starts the session and begins tracking motion data
    func startSession() {
        isSessionActive = true // Mark the session as active
        startTracking() // Begin tracking motion data
    }

    // Stops the session and halts motion data tracking
    func stopSession() {
        isSessionActive = false // Mark the session as inactive
        stopTracking() // Stop tracking motion data
        
        // Send the log file to the iPhone app
        if let logFileURL = logFileURL, session.isReachable {
            session.transferFile(logFileURL, metadata: nil)
        }
    }

    // Starts motion data tracking using CoreMotion
    func startTracking() {
        if motionManager.isDeviceMotionAvailable {
            // Check if the device motion sensors are available
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // Set the update interval (60 Hz)
            motionManager.startDeviceMotionUpdates(to: .main) { (motion, error) in
                // Start receiving motion data updates
                if let motion = motion {
                    self.processMotionData(motion: motion) // Process the received motion data
                }
            }
        }
    }

    // Stops motion data tracking
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates() // Stop receiving motion data updates
    }

    // Processes the motion data to calculate pitch speed and log it if session is active
    func processMotionData(motion: CMDeviceMotion) {
        let acceleration = motion.userAcceleration
        // Calculate the resultant acceleration magnitude
        let resultantAcceleration = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
        let pitchSpeed = estimatePitchSpeed(velocity: resultantAcceleration)
        // Update the UI with the calculated pitch speed
        self.pitchSpeed = String(format: "%.1f", pitchSpeed)

        // If the session is active, log the motion data
        if isSessionActive {
            logData(motion: motion)
        }
    }

    // Estimates the pitch speed based on the acceleration and a conversion factor
    func estimatePitchSpeed(velocity: Double) -> Double {
        let conversionFactor = 5.0  // This factor will need calibration
        return velocity * conversionFactor
    }

    // Logs the motion data to the file
    func logData(motion: CMDeviceMotion) {
        guard let logFileURL = logFileURL else { return } // Ensure the log file URL is valid
        let dataString = "Acceleration: \(motion.userAcceleration), Rotation: \(motion.rotationRate)\n"
        // Prepare the data to be written to the log file
        if let data = dataString.data(using: .utf8) {
            // Attempt to open the log file for writing
            if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                fileHandle.seekToEndOfFile() // Move to the end of the file
                fileHandle.write(data) // Write the data to the file
                fileHandle.closeFile() // Close the file to save changes
            }
        }
    }
}

// SwiftUI preview for development, allows you to see the UI in Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

