//
//  String+Timepiece.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2015/03/01.
//  Copyright (c) 2015年 Naoto Kaneko. All rights reserved.
//

import Foundation

extension String {
    // MARK - Parse into NSDate

    func dateFromFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    
    func getFormateDate(fromFormate:String, toFormate:String) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = fromFormate
        if let date = dateFormatter.date(from: self) {
            let toFormatter = DateFormatter.init()
            toFormatter.dateFormat = toFormate
            if let sDate = toFormatter.string(from: date) as? String {
                return sDate
            }
        }
        return ""
    }
   
 
}
extension Int {
// MARK - Parse into NSDate

   func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
  }
}
extension String {
    func formatMessage() -> String {
        let trimmedMsg = self.trimmingCharacters(in: .whitespacesAndNewlines)
          
        // If the trimmed message is empty, return an empty string
        guard !trimmedMsg.isEmpty else {
            return ""
        }
          
        let words = trimmedMsg.components(separatedBy: " ")
          
        guard let firstWord = words.first else {
            return ""
        }
          
        var formattedFirstWord = firstWord.prefix(1).uppercased() + firstWord.dropFirst().lowercased()
          
        if words.count > 1 {
            for i in 1..<words.count {
                formattedFirstWord += " " + words[i].lowercased()
            }
        }
        
        // Remove double spaces
        var finalMessage = formattedFirstWord.replacingOccurrences(of: "  ", with: " ")
          
        // Check if the original message already ends with a period
        if self.last == "."  || words.count < 2 {
            return finalMessage
        }
          
        return finalMessage + "."
    }
    func capitalizeFirstLetter() -> String {
        guard !self.isEmpty else {
            return ""
        }
        
        let firstLetter = self.prefix(1).uppercased()
        let restOfString = self.dropFirst().lowercased()
        
        return firstLetter + restOfString
    }
}
