//
//  DailyWeather+CoreDataProperties.swift
//  WeatherWizard
//
//  Created by Lasse Pettersen on 03/11/2020.
//
//

import Foundation
import CoreData


extension DailyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }

    @NSManaged public var advice: String?
    @NSManaged public var day: String?
    @NSManaged public var iconName: String?
    @NSManaged public var sortId: Int64

}

extension DailyWeather : Identifiable {

}
