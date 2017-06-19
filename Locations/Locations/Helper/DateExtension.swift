//
//  DateExtension.swift
//  Locations
//
//  Created by Toheed Khan on 10/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import Foundation

public extension Date {
    
    
    static func dateFromISODateTime(_ isoDateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone.default
        
        return dateFormatter.date(from: isoDateString)!
    }
    
    static func dateStringFromDateInDefaultTimeZone(_ date: Date) -> String {
       let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        return dateFormatter.string(from:date)
    }
    
    static func timeDifference(from fromDate: Date, to toDate: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        let userCalendar = NSCalendar.current
        let requestedComponent: Set<Calendar.Component> = [.day,.hour,.minute,.second]

        let timeDifference = userCalendar.dateComponents(requestedComponent, from: fromDate, to: toDate)
        
        var timeDifferenceDescription: String?
        
        if let day = timeDifference.day, day > 0 {
              timeDifferenceDescription = "\(String(describing:day))" + (day > 1 ? " days" : " day")
        }
        
        if let hour = timeDifference.hour, hour > 0 {
            if (timeDifferenceDescription != nil) && (timeDifferenceDescription?.characters.count)! > 0 {
                timeDifferenceDescription?.append(" \(String(describing: hour))" + (hour > 1 ? " hours" : " hour"))
            }
            else {
                timeDifferenceDescription = "\(String(describing: hour))" + (hour > 1 ? " hours" : " hour")
            }
        }
        
        if let minute = timeDifference.minute, minute > 0 {
            if (timeDifferenceDescription != nil) && (timeDifferenceDescription?.characters.count)! > 0 {
                timeDifferenceDescription?.append(" \(String(describing: minute))" + (minute > 1 ? " minutes" : " minute"))
            }
            else {
                timeDifferenceDescription = "\(String(describing: minute))" + (minute > 1 ? " minutes" : " minute")
            }
        }
        
        if let second = timeDifference.second, second > 0 {
            if (timeDifferenceDescription != nil) && (timeDifferenceDescription?.characters.count)! > 0 {
                timeDifferenceDescription?.append(" \(String(describing: second))" + (second > 1 ? " seconds" : " second"))
            }
            else {
                timeDifferenceDescription = "\(String(describing: second))" + (second > 1 ? " seconds" : " second")
            }
        }
        
        return (timeDifferenceDescription == nil) ?"0 seconds" :timeDifferenceDescription

    }
}
