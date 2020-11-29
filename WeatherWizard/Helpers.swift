//
//  Helpers.swift
//  WeatherWizard
//

import Foundation


struct Helpers {
    
    static func dateStringToDay(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "cccc"
        dateFormatter.locale = Locale(identifier: "no_NO")
        let weekday = dateFormatter.string(from: date)
        
        return weekday.capitalized
    }
    
    static func dateTimeString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "no_NO")
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
}
