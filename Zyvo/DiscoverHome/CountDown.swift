//
//  CountDown.swift
//  Zyvo
//
//  Created by ravi on 13/03/25.
//

import Foundation

class CurrentDateTimer {
    
    static let shared = CurrentDateTimer()
    private var timer: Timer?
    private var completion: ((String, String) -> Void)?

    func startTimer(completion: @escaping (String, String) -> Void) {
        self.completion = completion
        timer?.invalidate()

        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateDateAndTime), userInfo: nil, repeats: true)
    }

    @objc private func updateDateAndTime() {
        let currentDate = Date()

        // Formatter for date only
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let currentDateString = dateFormatter.string(from: currentDate)

        // Formatter for date and time
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTimeFormatter.timeZone = TimeZone.current
        let currentDateTimeString = dateTimeFormatter.string(from: currentDate)

        // Pass both date and date-time to completion handler
        completion?(currentDateString, currentDateTimeString)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Timer stopped.")
    }
}

// Calculate time Difference

class TimeDifferenceCalculator {
    func calculateTimeDifference(startTimeString: String, endTimeString: String) -> (hours: Int, minutes: Int, seconds: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let startTime = dateFormatter.date(from: startTimeString),
              let endTime = dateFormatter.date(from: endTimeString) else {
            print("Invalid date format")
            return nil
        }
        
        let difference = endTime.timeIntervalSince(startTime) // Difference in seconds
        
        let hours = Int(difference) / 3600
        let minutes = (Int(difference) % 3600) / 60
        let seconds = Int(difference) % 60
        
        return (hours, minutes, seconds)
    }
}
