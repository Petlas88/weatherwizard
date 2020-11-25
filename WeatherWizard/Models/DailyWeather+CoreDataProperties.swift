//
//  DailyWeather+CoreDataProperties.swift
//  WeatherWizard
//

import Foundation
import CoreData


extension DailyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }

    @NSManaged public var advice: String?
    @NSManaged public var updateTime: String?
    @NSManaged public var day: String?
    @NSManaged public var iconName: String?
    @NSManaged public var sortId: Int64

}

extension DailyWeather : Identifiable {

}
