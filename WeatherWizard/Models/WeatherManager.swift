//
//  Weathermanager.swift
//  WeatherWizard
//
// The contents of this file is reused from a course I followed on Udemy to learn Swift.
// However, the contens of this is file is entirely written out by me again during this exam, but is heavely inspired by the course. All logic related to this specific app is also done by me.
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
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
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
            //  Fetching data from timeseries index 1 as index 0 seems to be one hour in the past. Index 1 seems to be more accurate to actual time.
            //  Units
            let millimeterSurfix = decodedData.properties.meta.units.precipitationAmount
            let celciusSurfix = decodedData.properties.meta.units.airTemperature
            //  Instant data
            let temperature = "\(decodedData.properties.timeseries[1].data.instant.details.airTemperature) \(celciusSurfix)"
            //  One hour data
            let oneHourCondition = decodedData.properties.timeseries[1].data.next1Hours!.summary.symbolCode
            let oneHourRain = "\(decodedData.properties.timeseries[1].data.next1Hours!.details.precipitationAmount) \(millimeterSurfix)"
            //  Six hour data
            let sixHourCondition = decodedData.properties.timeseries[1].data.next6Hours!.summary.symbolCode
            let sixHourRain = "\(decodedData.properties.timeseries[1].data.next6Hours!.details.precipitationAmount) \(millimeterSurfix)"
            //  Twelve hour data
            let twelveHourCondition = decodedData.properties.timeseries[1].data.next12Hours!.summary.symbolCode
            //  Location coordinates (for MapWeather)
            let latitude = String(decodedData.geometry.coordinates[1])
            let longitude = String(decodedData.geometry.coordinates[0])
            //  Timeseries (for Home screen)
            var timeseries: [Weekday] = []
            
            //  Will always append the first index of timeseries, as we can't know at what time the user opens the app
            timeseries.append(Weekday(day: decodedData.properties.timeseries[0].time, condition: (decodedData.properties.timeseries[0].data.next6Hours?.summary.symbolCode)!))
          
            
            //  Then we add entries which are for 6 am until the array contains 7 entries
            for timesery in decodedData.properties.timeseries {
                let timeSeryDate = timesery.time.split(separator: "T")[0]
                let inArray: Bool = (timeSeryDate == timeseries[0].day.split(separator: "T")[0])
                if timesery.time.contains("06:00") && !inArray && timeseries.count < 7 {
                    timeseries.append(Weekday(day: timesery.time, condition: (timesery.data.next6Hours?.summary.symbolCode)!))
                }
            }
            
            let weather = WeatherModel(temperature: temperature, oneHourCondition: oneHourCondition, oneHourRain: oneHourRain, sixHourCondition: sixHourCondition, sixHourRain: sixHourRain, twelveHourCondition: twelveHourCondition, millimeterSurfix: millimeterSurfix, celciusSurfix: celciusSurfix, latitude: latitude, longitude: longitude, weekdays: timeseries)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
