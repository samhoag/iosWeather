//
//  WeatherDetailedForecastModel.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/4/24.
//

import Foundation


extension WDFPropertyValue: Identifiable {}


struct WeatherDetailedForecast: Codable {
    let id = UUID()
    let type: String
    let geometry: WDFGeometry
    let properties: WDFProperties
    
}

struct WDFGeometry: Codable {
    let id = UUID()
    let type: String
    let coordinates: [[[Float]]]
}

struct WDFProperties: Codable {
    let updateTime: String
    let validTimes: String
    //let elevation: WDFProperty
    let temperature: WDFProperty
    let dewpoint: WDFProperty
    let maxTemperature: WDFProperty
    let minTemperature: WDFProperty
    let relativeHumidity: WDFProperty
    let apparentTemperature: WDFProperty
    let wetBulbGlobeTemperature: WDFProperty
    //let heatIndex: WDFProperty
    //let windChill: WDFProperty
    let skyCover: WDFProperty
    let windDirection: WDFProperty
    let windSpeed: WDFProperty
    let windGust: WDFProperty
    let weather: WDFWeatherProperty
}

struct WDFProperty: Codable {
    let uom: String
    let values: [WDFPropertyValue]
}

struct WDFPropertyValue: Codable {
    let id = UUID()
    let validTime: String
    let value: Float?
    
    private enum CodingKeys: String, CodingKey {
        case validTime
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validTime = try container.decode(String.self, forKey: .validTime)
        if let intValue = try? container.decode(Int.self, forKey: .value) {
            value = Float(intValue)
        } else if let floatValue = try? container.decode(Float.self, forKey: .value) {
            value = floatValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Invalid value type. Expected Int or Float.")
        }
    }
}

struct WDFWeatherProperty: Codable {
    let values: [WDFWeatherPropertyValue]
}

struct WDFWeatherPropertyValue: Codable {
    let validTime: String
    let value: [WDFWeatherPropertyValueValue]
}

struct WDFWeatherPropertyValueValue: Codable {
    let coverage: String?
    let weather: String?
    let intensity: String?
    let visibility: WDFWeatherPropertyVisibility
}

struct WDFWeatherPropertyVisibility: Codable {
    let unitcode: String?
    let value: Float?
}
