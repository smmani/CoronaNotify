//
//  RegionMonitor.swift
//  KFCNotify
//
//  Created by Selvakumar Murugan on 10/04/21.
//  Copyright © 2021 Mani. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class RegionMonitor : UIResponder{
    
    static let onEntryOrExit = "EntryOrExitRegion"
    
    static let shared = RegionMonitor()
    let locationManager = CLLocationManager()
    
    override init() {
        
    }
    
    func startLocationMonitoring() {
        let lati = [12.9905,12.8480,13.0499]
        let long = [80.2170,80.2399,80.2095]
        
        let Titlls = ["Phoenix Marketcity","Forum Vijaya Mall","Mayajaal Multiplex"]
        
        
        let radius = [1000.0,1000.0,1000.0]
        
        for i in 0..<lati.count {
                let event  = RegionEvent()
                event.latitude = lati[i]
                event.longitude = long[i]
                event.radius = radius[i]
                event.note = Titlls[i]
                event.identifier = Titlls[i]
                
                self.registerGeoFence(obj: event)
        }
        
    }
    
    // MARK: GeoFance Management
    func registerGeoFence(obj : RegionEvent) {
        
        if locationManager.monitoredRegions.count >= 20
        {
            locationManager.stopMonitoring(for: locationManager.monitoredRegions.first!)
        }
        let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(obj.latitude, obj.longitude)
        let region = CLCircularRegion(center: centerCoordinate, radius: obj.radius, identifier: obj.identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
    }
    
    func enableLocationServices()
    {        
        locationManager.delegate = self
        var isNeedToBringSettings = false
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            print("status restricted, .denied \(CLLocationManager.authorizationStatus())")
            isNeedToBringSettings = true
            break
            
        case .authorizedWhenInUse:
            print("status authorizedWhenInUse \(CLLocationManager.authorizationStatus())")
            break
            
        case .authorizedAlways:
            print("status authorizedAlways \(CLLocationManager.authorizationStatus())")
            
            break
        
        @unknown default:
            print("Unknown authorizedAlways \(CLLocationManager.authorizationStatus())")
            isNeedToBringSettings = true
            break
        }
        if isNeedToBringSettings {
            self.bringSettingsToEnableLocation()
        }
    }
    
    func bringSettingsToEnableLocation() {
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        UIApplication.topViewController(base: nil)?.present(alertController, animated: true, completion: nil)
    }
    
}

extension RegionMonitor: CLLocationManagerDelegate {
    
    func insertEventforRegion(region : CLCircularRegion, eventType : RegionEvent.EventType) {
        let regionEvent = RegionEvent()
        regionEvent.latitude = region.center.latitude
        regionEvent.longitude = region.center.longitude
        regionEvent.identifier = region.identifier
        regionEvent.radius = region.radius
        regionEvent.eventType = eventType
        regionEvent.eventTime = Utils.getCurrentTimeString()
        CoreDataManager.shared.insertEventLog(event: regionEvent)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: RegionMonitor.onEntryOrExit)))
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            if region is CLCircularRegion {
                print("Did Enter region called....")
                insertEventforRegion(region: region as! CLCircularRegion, eventType: .onEntry)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("Did Exit region called....")
            insertEventforRegion(region: region as! CLCircularRegion, eventType: .onExit)
        }
    }
}
