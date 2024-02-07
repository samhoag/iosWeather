//
//  WeatherForcast.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/3/24.
//

import Foundation
extension WeatherItem: Identifiable {}
extension WeatherPeriod: Identifiable {}


struct WeatherItem: Codable {
    let id = UUID()
    let properties: WeatherProperties
}

struct WeatherProperties: Codable {
    let periods: [WeatherPeriod]
}

struct WeatherPeriod: Codable {
    let id = UUID()
    let number: Int
    var name: String
    let temperature: Int
    let temperatureUnit: String
    let windSpeed: String
    let windDirection: String
    let shortForecast: String
    let detailedForecast: String
    let icon: String
    let probabilityOfPrecipitation: WeatherPeriodProbabilityOfPrecipitiation
}

struct WeatherPeriodProbabilityOfPrecipitiation: Codable {
    let unitCode: String
    let value: Int?
}

