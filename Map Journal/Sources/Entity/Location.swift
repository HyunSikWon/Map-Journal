//
//  Location.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/10.
//

import Foundation
import CoreLocation

class Location: Codable {
  let description: String
//  let date: Date
//  let dateString: String
  let latitude: Double
  let longtitude: Double
  var memos: [Memo] = []
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
  }
  
  init(_ location: CLLocation, description: String) {
    latitude = location.coordinate.latitude
    longtitude = location.coordinate.longitude
    self.description = description
  }
}


