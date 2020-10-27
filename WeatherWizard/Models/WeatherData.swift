//
//  WeatherModel.swift
//  WeatherWizard
//


import Foundation

struct WeatherData {
    let properties: String
    let timeseries: [Timeseries]
    
}

struct Timeseries {
    let data: String
    let instant: String
    let details: String
    let temperature: Temperature
}

struct Temperature {
    let air_temperature: Double
}


//properties.timeseries[0].data.instant.details.air_temperature
