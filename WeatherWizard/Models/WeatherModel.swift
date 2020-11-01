//
//  WeatherModel.swift
//  WeatherWizard
//

import Foundation
import UIKit


struct WeatherModel {
    let temperature: String
    let oneHourCondition: String
    let oneHourRain: String
    let sixHourCondition: String
    let sixHourRain: String
    let twelveHourCondition: String
    let millimeterSurfix: String
    let celciusSurfix: String
    let latitude: String
    let longitude: String
    let time: String
    
    
    //    Converting symbol codes to conditions based on input
    func getWeatherCondition(timeSpan: String) -> String {
        switch timeSpan {
        case K.clearSky, K.clearSkyDay, K.clearSkyNight, K.clearSkyTwilight:
            return "Sol"
        case K.cloudy:
            return "Overskyet"
        case K.fair, K.fairDay, K.fairNight, K.fairTwilight:
            return "Lettskyet"
        case K.fog:
            return "Tåke"
        case K.heavyRain:
            return "Kraftig regn"
        case K.heavyRainAndThunder:
            return "Kraftig regn og torden"
        case K.heavyRainShowers, K.heavyRainShowersDay, K.heavyRainShowersNight, K.heavyRainShowersTwilight:
            return "Kraftige regnbyger"
        case K.heavyRainShowersAndThunder, K.heavyRainShowersAndThunderDay, K.heavyRainShowersAndThunderNight, K.heavyRainShowersAndThunderTwilight:
            return "Kraftige regnbyger og torden"
        case K.heavySleet:
            return "Kraftig sludd"
        case K.heavySleetAndThunder:
            return "Kraftig sludd og torden"
        case K.heavySleetShowers, K.heavySleetShowersDay, K.heavySleetShowersNight, K.heavySleetShowersTwilight:
            return "Kraftige sluddbyger"
        case K.heavySleetShowersAndThunder, K.heavySleetShowersAndThunderDay, K.heavySleetShowersAndThunderNight, K.heavySleetShowersAndThunderTwilight:
            return "Kraftige sluddbyger og torden"
        case K.heavySnow:
            return "Kraftig snø"
        case K.heavySnowAndThunder:
            return "Kraftig snø og torden"
        case K.heavySnowShowers, K.heavySnowShowersDay, K.heavySnowShowersNight, K.heavySnowShowersTwilight:
            return "Kraftige snøbyger"
        case K.heavySnowShowersAndThunder, K.heavySnowShowersAndThunderDay, K.heavySnowShowersAndThunderNight, K.heavySnowShowersAndThunderTwilight:
            return "Kraftige snøbyger og torden"
        case K.lightRain:
            return "Lett regn"
        case K.lightRainAndThunder:
            return "Lett regn og torden"
        case K.lightRainShowers, K.lightRainShowers + K.dayVariant, K.lightRainShowers + K.nightVariant, K.lightRainShowers + K.twilightVariant:
            return "Lette regnbyger"
        case K.lightRainShowersAndThunder, K.lightRainShowersAndThunderDay, K.lightRainShowersAndThunderNight, K.lightRainShowersAndThunderTwilight:
            return "Lette regbyger og torden"
        case K.lightSleet:
            return "Lett sludd"
        case K.lightSleetAndThunder:
            return "Lett sludd og torden"
        case K.lightSleetShowers, K.lightSleetShowersDay, K.lightSleetShowersNight, K.lightSleetShowersTwilight:
            return "Lette sluddbyger"
        case K.lightSnow:
            return "Lett snø"
        case K.lightSnowAndThunder:
            return "Lett snø og torden"
        case K.lightSnowShowers, K.lightSnowShowersDay, K.lightSnowShowersNight, K.lightSnowShowersTwilight:
            return "Lette snøbyger"
        case K.lightSleetShowersAndThunder, K.lightSleetShowersAndThunderDay, K.lightSleetShowersAndThunderNight, K.lightSleetShowersAndThunderTwilight:
            return "Lette sluddbyger og torden"
        case K.lightSnowShowerAndThunder, K.lightSnowShowerAndThunderDay, K.lightSnowShowerAndThunderNight, K.lightSnowShowerAndThunderTwilight:
            return "Lette snøbyger og torden"
        case K.partlyCloudly, K.partlyCloudlyDay, K.partlyCloudlyNight, K.partlyCloudlyTwilight:
            return "Delvis skyet"
        case K.rain:
            return "Regn"
        case K.rainAndThunder:
            return "Regn og torden"
        case K.rainShowers, K.rainShowersDay, K.rainShowersNight, K.rainShowersTwilight:
            return "Regnbyger"
        case K.rainShowersAndThunder, K.rainShowersAndThunderDay, K.rainShowersAndThunderNight, K.rainShowersAndThunderTwilight:
            return "Regnbyger og torden"
        case K.sleet:
            return "Sludd"
        case K.sleetAndThunder:
            return "Sludd og torden"
        case K.sleetShowers, K.sleetShowersDay, K.sleetShowersNight, K.sleetShowersTwilight:
            return "Sluddbyger"
        case K.sleetShowersAndThunder, K.sleetShowersAndThunderDay, K.sleetShowersAndThunderNight, K.sleetShowersAndThunderTwilight:
            return "Sluddbyger og torden"
        case K.snow:
            return "Snø"
        case K.snowAndThunder:
            return "Snø og torden"
        case K.snowShowers, K.snowShowersDay, K.snowShowersNight, K.snowShowersTwilight:
            return "Snøbyger"
        case K.snowShowersAndThunder, K.snowShowersAndThunderDay, K.snowShowersAndThunderNight, K.snowShowersAndThunderTwilight:
            return "Snøbyger og torden"
        default:
            return "Overskyet"
        }
    }
}
