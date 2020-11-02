//
//  Helpers.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 02/11/2020.
//

import Foundation


struct Helpers {
    
    func dateStringToDay(dateString: String) -> String {
        
        let timeRemovedT = dateString.replacingOccurrences(of: "T", with: " ")
        let formattedTime = timeRemovedT.replacingOccurrences(of: "Z", with: ".0")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        let date = dateFormatter.date(from: formattedTime)!
        dateFormatter.dateFormat = "cccc"
        dateFormatter.locale = Locale(identifier: "no_NO")
        let weekday = dateFormatter.string(from: date)
        
        return weekday.capitalized
    }
    
}

//MARK: - StringProtocol extension
extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
