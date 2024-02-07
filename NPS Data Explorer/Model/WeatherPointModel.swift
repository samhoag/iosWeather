//
//  WeatherPointModel.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/4/24.
//

import Foundation

struct WeatherPoint: Codable {
    let id = UUID()
    let properties: WeatherPointProperties
}

struct WeatherPointProperties: Codable {
    let id = UUID()
    let cwa: String
    let forecastOffice: URL
    let gridId: String
    let gridX: Int
    let gridY: Int
    let forecast: URL
    let forecastHourly: URL
    let forecastGridData: URL
    let observationStations: URL
    let forecastZone: URL
    let county: URL
    let fireWeatherZone: URL
    let timeZone: String
    let radarStation: String
    let relativeLocation: WeatherPointRelativeLocation
}

struct WeatherPointRelativeLocation: Codable {
    let id = UUID()
    let type: String
    let geometry: WeatherPointRelativeLocationGeometry
    let properties: WeatherPointRelativeLocationProperties
    
}

struct WeatherPointRelativeLocationGeometry: Codable {
    let id = UUID()
    let type: String
    let coordinates: [Float]
}

struct WeatherPointRelativeLocationProperties: Codable {
    let id = UUID()
    let city: String
    let state: String
}
