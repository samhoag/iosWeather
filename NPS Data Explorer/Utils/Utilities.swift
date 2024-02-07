//
//  Utilities.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/3/24.
//

// Utilities.swift

import Foundation
import SwiftUI

/// Utility functions for common tasks.
struct Utilities {
    
    static func capitalizeFirstCharOnly(rawText: String) -> String {
        return rawText.prefix(1).capitalized + rawText.dropFirst().lowercased()
    }
    
    static func getWeatherAPIEndPoint(lat: String, long: String) -> String{
        return "https://api.weather.gov/points/\(lat),\(long)"
    }
    
    static func celciusToFahrenheit(c: Float) -> Int {
        return Int(round(c * (9/5) + 32))
    }
    
    static func fetchEndPointData() {
        return
    }
    
    static func writeWeatherShortDesc(data: WDFProperties) -> String
    {
        var desc = ""
        let skyCover = data.skyCover.values[0].value ?? -1
        switch skyCover{
        case 0..<10:
            desc = "Clear"
        case 10..<50:
            desc = "Partly cloudy"
        case 50...:
            desc = "Cloudy"
        default:
            desc = "Go look outside bum"
        }
        
        return desc
    }
    
    static func writeWeatherLongDesc(data: WDFProperties) -> String
    {
        return "This text is a detailed description of today's forecasted weather conditions. It may include cloud cover, temperatures, winds, possible severe weather, or any other relevant and reasonable conclusions that might be drawn from the grid data from the API"
    }
    
    static func dateTimeParser(datetime: String) -> (Int, Bool){
        // Create an ISO8601DateFormatter instance
        let dateFormatter = ISO8601DateFormatter()

        // Parse the datetime string to get the start date
        if let startDate = dateFormatter.date(from: datetime) {
            // Extract the hour component from the start date
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: startDate)
            return (hour % 12, hour < 12) // first elem is the time. second is am/pm. true is am, false is pm
        } else {
            print("Invalid datetime string")
            return (-1, false)
        }
        
    }
    
    static func dateTimeParser24(datetime: String) -> Int{
        // Create an ISO8601DateFormatter instance
        let dateFormatter = ISO8601DateFormatter()

        // Parse the datetime string to get the start date
        if let startDate = dateFormatter.date(from: datetime) {
            // Extract the hour component from the start date
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: startDate)
            return hour
        } else {
            print("Invalid datetime string")
            return -1
        }
        
    }
    
    static func selectBackground(timeHour24: Int) -> String{
        
        if 5 < timeHour24 && timeHour24 < 19 {
            return "clearday4"
        } else {
            return "clearnight"
        }

    }
}
