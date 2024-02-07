//
//  GeocodeModel.swift
//  NPS Data Explorer
//
//  Created by Sam Hoag on 2/4/24.
//

import Foundation

struct GeocodeLocation: Codable {
    let id = UUID()
    let placeId: Int
    let licence: String
    let osmType: String
    let osmId: Int
    let boundingBox: [String]
    let lat: String
    let lon: String
    let displayName: String
    let classType: String
    let type: String
    let importance: Double
    
    var city: String {
        return String(displayName.split(separator: ",")[0])
    }
    
    var county: String {
        return String(displayName.split(separator: ",")[1])
    }
    
    var state: String {
        return String(displayName.split(separator: ",")[2])
    }
    
    var country: String {
        return String(displayName.split(separator: ",")[3])
    }
    
    private enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case licence
        case osmType = "osm_type"
        case osmId = "osm_id"
        case boundingBox = "boundingbox"
        case lat
        case lon
        case displayName = "display_name"
        case classType = "class"
        case type
        case importance
    }
}
