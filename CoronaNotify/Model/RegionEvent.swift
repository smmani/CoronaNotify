//
//  RegionEvent.swift
//  KFCNotify
//
//  Created by Selvakumar Murugan on 10/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class RegionEvent{
    enum EventType: String {
      case onEntry = "On Entry"
      case onExit = "On Exit"
    }
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius : Double = 100.0
    var identifier: String = ""
    var note: String = ""
    var eventType: EventType = .onEntry

    var title: String? {
      if note.isEmpty {
        return "No Note"
      }
      return note
    }
    
    init() {
    }
}

