//
//  Weathermanager.swift
//  WeatherWizard
//
// This file was partly created before the exam as a part of a Udemy course I followed to learn swift.
// However, the contens of this is file is entirely written out by me, but is heavely inspired by the course.
// Course link: https://www.udemy.com/course/ios-13-app-development-bootcamp/

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.met.no/weatherapi/locationforecast/2.0/compact.json?"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees)  {
        let urlString = "\(weatherUrl)lat=\(lat)&lon=\(lon)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String)  {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //Needed the self. notation in the past, seems to be working fine without it now (Swift 5, Xcode 12.1)
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //Needed the self. notation in the past, seems to be working fine without it now (Swift 5, Xcode 12.1)
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            //            Units
            let millimeterSurfix = decodedData.properties.meta.units.precipitationAmount
            let celciusSurfix = decodedData.properties.meta.units.airTemperature
            //            Instant data
            let temperature = "\(decodedData.properties.timeseries[0].data.instant.details.airTemperature) \(celciusSurfix)"
            //            One hour data
            let oneHourCondition = decodedData.properties.timeseries[0].data.next1Hours!.summary.symbolCode
            let oneHourRain = "\(decodedData.properties.timeseries[0].data.next1Hours!.details.precipitationAmount) \(millimeterSurfix)"
            //            Six hour data
            let sixHourCondition = decodedData.properties.timeseries[0].data.next6Hours!.summary.symbolCode
            let sixHourRain = "\(decodedData.properties.timeseries[0].data.next6Hours!.details.precipitationAmount) \(millimeterSurfix)"
            //            Twelve hour data
            let twelveHourCondition = decodedData.properties.timeseries[0].data.next12Hours!.summary.symbolCode
            //            Location coordinates (for MapWeather)
            let latitude = String(decodedData.geometry.coordinates[0])
            let longitude = String(decodedData.geometry.coordinates[1])
            
            let weather = WeatherModel(temperature: temperature, oneHourCondition: oneHourCondition, oneHourRain: oneHourRain, sixHourCondition: sixHourCondition, sixHourRain: sixHourRain, twelveHourCondition: twelveHourCondition, millimeterSurfix: millimeterSurfix, celciusSurfix: celciusSurfix, latitude: latitude, longitude: longitude)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
