//
//  Constants.swift
//  WeatherWizard
//

import Foundation

struct K {
    static let appName = "WeatherWizard"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "ForecastCell"
    static let mapWeatherName = "MapWeather"
    static let entityName = "DailyWeather"
    
    
    //    Symbol codes from API
    static let clearSky = "clearsky"
    static let clearSkyDay = "clearsky_day"
    static let clearSkyNight = "clearsky_night"
    static let clearSkyTwilight = "clearsky_polartwilight"
    static let cloudy = "cloudy"
    static let fair = "fair"
    static let fairDay = "fair_day"
    static let fairNight = "fair_night"
    static let fairTwilight = "fair_polartwilight"
    static let fog = "fog"
    static let heavyRain = "heavyrain"
    static let heavyRainAndThunder = "heavyrainandthunder"
    static let heavyRainShowers = "heavyrainshowers"
    static let heavyRainShowersDay = "heavyrainshowers_day"
    static let heavyRainShowersNight = "heavyrainshowers_night"
    static let heavyRainShowersTwilight = "heavyrainshowers_polartwilight"
    static let heavyRainShowersAndThunder = "heavyrainshowersandthunder"
    static let heavyRainShowersAndThunderDay = "heavyrainshowersandthunder_day"
    static let heavyRainShowersAndThunderNight = "heavyrainshowersandthunder_night"
    static let heavyRainShowersAndThunderTwilight = "heavyrainshowersandthunder_polartwilight"
    static let heavySleet = "heavysleet"
    static let heavySleetAndThunder = "heavysleetandthunder"
    static let heavySleetShowers = "heavysleetshowers"
    static let heavySleetShowersDay = "heavysleetshowers_day"
    static let heavySleetShowersNight = "heavysleetshowers_night"
    static let heavySleetShowersTwilight = "heavysleetshowers_polartwilight"
    static let heavySleetShowersAndThunder = "heavysleetshowersandthunder"
    static let heavySleetShowersAndThunderDay = "heavysleetshowersandthunder_day"
    static let heavySleetShowersAndThunderNight = "heavysleetshowersandthunder_night"
    static let heavySleetShowersAndThunderTwilight = "heavysleetshowersandthunder_polartwilight"
    static let heavySnow = "heavysnow"
    static let heavySnowAndThunder = "heavysnowandthunder"
    static let heavySnowShowers = "heavysnowshowers"
    static let heavySnowShowersDay = "heavysnowshowers_day"
    static let heavySnowShowersNight = "heavysnowshowers_night"
    static let heavySnowShowersTwilight = "heavysnowshowers_polartwilight"
    static let heavySnowShowersAndThunder = "heavysnowshowersandthunder"
    static let heavySnowShowersAndThunderDay = "heavysnowshowersandthunder_day"
    static let heavySnowShowersAndThunderNight = "heavysnowshowersandthunder_night"
    static let heavySnowShowersAndThunderTwilight = "heavysnowshowersandthunder_polartwilight"
    static let lightRain = "lightrain"
    static let lightRainAndThunder = "lightrainandthunder"
    static let lightRainShowers = "lightrainshowers"
    static let lightRainShowersDay = "lightrainshowers_day"
    static let lightRainShowersNight = "lightrainshowers_night"
    static let lightRainShowersTwilight = "lightrainshowers_polartwilight"
    static let lightRainShowersAndThunder = "lightrainshowersandthunder"
    static let lightRainShowersAndThunderDay = "lightrainshowersandthunder_day"
    static let lightRainShowersAndThunderNight = "lightrainshowersandthunder_night"
    static let lightRainShowersAndThunderTwilight = "lightrainshowersandthunder_twilight"
    static let lightSleet = "lightsleet"
    static let lightSleetAndThunder = "lightsleetandthunder"
    static let lightSleetShowers = "lightsleetshowers"
    static let lightSleetShowersDay = "lightsleetshowers_day"
    static let lightSleetShowersNight = "lightsleetshowers_night"
    static let lightSleetShowersTwilight = "lightsleetshowers_polartwilight"
    static let lightSnow = "lightsnow"
    static let lightSnowAndThunder = "lightsnowandthunder"
    static let lightSnowShowers = "lightsnowshowers"
    static let lightSnowShowersDay = "lightsnowshowers_day"
    static let lightSnowShowersNight = "lightsnowshowers_night"
    static let lightSnowShowersTwilight = "lightsnowshowers_polartwilight"
    static let lightSleetShowersAndThunder = "lightssleetshowersandthunder"
    static let lightSleetShowersAndThunderDay = "lightssleetshowersandthunder_day"
    static let lightSleetShowersAndThunderNight = "lightssleetshowersandthunder_night"
    static let lightSleetShowersAndThunderTwilight = "lightssleetshowersandthunder_polartwilight"
    static let lightSnowShowerAndThunder = "lightssnowshowersandthunder"
    static let lightSnowShowerAndThunderDay = "lightssnowshowersandthunder_day"
    static let lightSnowShowerAndThunderNight = "lightssnowshowersandthunder_night"
    static let lightSnowShowerAndThunderTwilight = "lightssnowshowersandthunder_polartwilight"
    static let partlyCloudly = "partlycloudy"
    static let partlyCloudlyDay = "partlycloudy_day"
    static let partlyCloudlyNight = "partlycloudy_night"
    static let partlyCloudlyTwilight = "partlycloudy_polartwilight"
    static let rain = "rain"
    static let rainAndThunder = "rainandthunder"
    static let rainShowers = "rainshowers"
    static let rainShowersDay = "rainshowers_day"
    static let rainShowersNight = "rainshowers_night"
    static let rainShowersTwilight = "rainshowers_polartwilight"
    static let rainShowersAndThunder = "rainshowersandthunder"
    static let rainShowersAndThunderDay = "rainshowersandthunder_day"
    static let rainShowersAndThunderNight = "rainshowersandthunder_night"
    static let rainShowersAndThunderTwilight = "rainshowersandthunder_polartwilight"
    static let sleet = "sleet"
    static let sleetAndThunder = "sleetandthunder"
    static let sleetShowers = "sleetshowers"
    static let sleetShowersDay = "sleetshowers_day"
    static let sleetShowersNight = "sleetshowers_night"
    static let sleetShowersTwilight = "sleetshowers_polartwilight"
    static let sleetShowersAndThunder = "sleetshowersandthunder"
    static let sleetShowersAndThunderDay = "sleetshowersandthunder_day"
    static let sleetShowersAndThunderNight = "sleetshowersandthunder_night"
    static let sleetShowersAndThunderTwilight = "sleetshowersandthunder_polartwilight"
    static let snow = "snow"
    static let snowAndThunder = "snowandthunder"
    static let snowShowers = "snowshowers"
    static let snowShowersDay = "snowshowers_day"
    static let snowShowersNight = "snowshowers_night"
    static let snowShowersTwilight = "snowshowers_polartwilight"
    static let snowShowersAndThunder = "snowshowersandthunder"
    static let snowShowersAndThunderDay = "snowshowersandthunder_day"
    static let snowShowersAndThunderNight = "snowshowersandthunder_night"
    static let snowShowersAndThunderTwilight = "snowshowersandthunder_polartwilight"
    static let nightVariant = "_night"
    static let dayVariant = "_day"
    static let twilightVariant = "_polartwilight"
}

