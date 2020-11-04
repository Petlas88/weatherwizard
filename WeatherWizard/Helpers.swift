//
//  Helpers.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 02/11/2020.
//

import Foundation


struct Helpers {
    
    func dateStringToDay(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "cccc"
        dateFormatter.locale = Locale(identifier: "no_NO")
        let weekday = dateFormatter.string(from: date)
        
        return weekday.capitalized
    }
    
}
