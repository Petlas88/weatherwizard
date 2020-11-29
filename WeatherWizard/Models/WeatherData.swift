// This file i created with QuickType (app.quicktype.io) 

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let geometry: Geometry
    let properties: Properties
}

// MARK: - Geometry
struct Geometry: Codable {
    let coordinates: [Double]
}

// MARK: - Properties
struct Properties: Codable {
    let meta: Meta
    let timeseries: [Timesery]
}

// MARK: - Meta
struct Meta: Codable {
    let updatedAt: String
    let units: Units
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case units
    }
}

// MARK: - Units
struct Units: Codable {
    let  airTemperature, precipitationAmount: String
    
    enum CodingKeys: String, CodingKey {
        case airTemperature = "air_temperature"
        case precipitationAmount = "precipitation_amount"
    }
}

// MARK: - Timesery
struct Timesery: Codable {
    let time: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let instant: Instant
    let next12Hours: Next12Hours?
    let next1Hours, next6Hours: NextHours?
    
    enum CodingKeys: String, CodingKey {
        case instant
        case next12Hours = "next_12_hours"
        case next1Hours = "next_1_hours"
        case next6Hours = "next_6_hours"
    }
}

// MARK: - Instant
struct Instant: Codable {
    let details: InstantDetails
}

// MARK: - InstantDetails
struct InstantDetails: Codable {
    let airPressureAtSeaLevel: Double
    let cloudAreaFraction, relativeHumidity, windFromDirection, windSpeed, airTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case airTemperature = "air_temperature"
        case cloudAreaFraction = "cloud_area_fraction"
        case relativeHumidity = "relative_humidity"
        case windFromDirection = "wind_from_direction"
        case windSpeed = "wind_speed"
    }
}

// MARK: - Next12Hours
struct Next12Hours: Codable {
    let summary: Summary
}

// MARK: - Summary
struct Summary: Codable {
    let symbolCode: String
    
    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

// MARK: - NextHours
struct NextHours: Codable {
    let summary: Summary
    let details: NextHoursDetails
}

// MARK: - NextHoursDetails
struct NextHoursDetails: Codable {
    let precipitationAmount: Double
    
    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}
