//
//  Forecast.swift
//  WeatherWizard
//

import Foundation

struct Forecast {
    let timeLabel: String
    let weatherLabel: String?
    let tempLabel: String?
    let condition: String?
    let degrees: String?
    let rain: String?
    
    
    init(timeSpan: String, condition: String? = nil, degrees: String? = nil, precipitation: String? = nil) {
        self.timeLabel = timeSpan
        self.weatherLabel = condition != nil ? "Vær" : nil
        self.tempLabel = degrees != nil ? "Temperatur" : nil
        self.condition = condition
        self.degrees = degrees
        self.rain = precipitation
        
    }
}
