//
//  WeatherModel.swift
//  WeatherWizard
//


import Foundation

struct WeatherData: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let timeseries: [Timeseries]
}

struct Timeseries: Codable {
    let data: DataModel
}

struct DataModel: Codable {
    let instant: Instant
    let next_12_hours: Next12Hours
    let next_1_hours: Next1Hours
    let next_6_hours: Next6Hours
}

struct Instant: Codable {
    let details: InstantDetails
}

struct InstantDetails: Codable {
    let air_temperature: Double
}

struct Next12Hours: Codable {
    let summary: Summary
}

struct Next1Hours: Codable {
    let summary: Summary
    let details: NextDetails
}

struct Next6Hours: Codable {
    let summary: Summary
    let details: NextDetails
    
}

struct Summary: Codable {
    let symbol_code: String
}

struct NextDetails: Codable {
    let precipitation_amount: Double
}




//properties.timeseries[0].data.instant.details.air_temperature
