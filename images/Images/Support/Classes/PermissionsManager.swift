//
//  PermissionsManager.swift
//  Images
//
//  Created by Bondar Yaroslav on 1/31/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import AVFoundation
import Photos
import CoreLocation
import Contacts
import CoreMotion

typealias AccessStatusHandler = (_ status: AccessStatus) -> Void

// TODO: AccessStatus.unavailable
/// .restricted: restricted by e.g. parental controls. User can't enable Location Services
/// .denied: user denied your app access to Location Services, but can grant access from Settings.app
final class PermissionsManager {
    
    /// KEYS Info.plist
    /** Example
    self.permissionsManager.requestCameraAccess { [weak self] result in
        guard let `self` = self else { return }
        
        switch result {
        case .success:
            self.openPicker(in: vc, for: .camera) { image in
                handler(image)
            }
        case .denied:
            self.settingsRouter.presentSettingsAlertForCameraAccess(in: vc)
        }
    }
     */
    func requestCameraAccess(handler: @escaping AccessStatusHandler) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            handler(.success)
        case .denied, .restricted:
            handler(.denied)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    handler(.success)
                } else {
                    handler(.denied)
                }
            }
        }
    }
    
    /// KEYS
    /** Example
    self.permissionsManager.requestPhotoAccess { [weak self] result in
        guard let `self` = self else { return}
        
        switch result {
        case .success:
            self.openPicker(in: vc, for: .photoLibrary) { image in
                handler(image)
            }
        case .denied:
            self.settingsRouter.presentSettingsAlertForPhotoAccess(in: vc)
        }
    }
     */
    func requestPhotoAccess(handler: @escaping AccessStatusHandler) {
        
        func requestPhotoAuthorization() {
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    handler(.success)
                case .denied, .restricted:
                    handler(.denied)
                case .notDetermined:
                    /// won't happen but still
                    handler(.denied)
                }
            }
        }
        
        func operationSystemVersionLessThen(_ version: Int) -> Bool {
            return ProcessInfo().operatingSystemVersion.majorVersion < version
        }
        
        /// bug “PHPhotoLibrary.authorizationStatus” is authorized in iOS 9 by default (checked on iPad)
        /// and "PHAssetResource.assetResources(for: ASSET).first" freezing the app
        if operationSystemVersionLessThen(10) {
            requestPhotoAuthorization()
            return
        }
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            handler(.success)
        case .denied, .restricted:
            handler(.denied)
        case .notDetermined:
            requestPhotoAuthorization()
        }
    }
    
    
    
    /// KEYS
    /** Example
     
    let locationManager = CLLocationManager()
     
    permissionsManager.requestLocationAccess(for: locationManager, request: .always) { [weak self] result in
        guard let `self` = self else { return}
         
        switch result {
        case .success:
            locationManager.startUpdatingLocation()
        case .denied:
            self.settingsRouter.presentSettingsAlertForLocationAccess(in: vc)
        }
    }
     */
    func requestLocationAccess(for locationManager: CLLocationManager?, request: LocationRequest, handler: @escaping AccessStatusHandler) {
        
        // TODO: maybe need to remove handleLocationAuthorization
        // TODO: request with .restricted
        ///Location services are disabled in your device settings. To use ..., you need to enable location services under \"Settings - Privacy - Location Services\" menu
        //if !CLLocationManager.locationServicesEnabled() {
        //    completion(.restricted)
        //    return
        //}        
        if CLLocationManager.locationServicesEnabled() {
            handleLocationAuthorization(status: CLLocationManager.authorizationStatus(),
                                        for: locationManager,
                                        request: request,
                                        handler: handler)
        } else {
            handler(.denied)
        }
    }
    
    /** Example
     
    /// 1
    func locationManagerRequestHandler2(_ status: AccessStatus) -> Void {
        weak var _self = self
        guard let `self` = _self else { return }
        
        switch result {
        case .success:
            locationManager.startUpdatingLocation()
        case .denied:
            self.settingsRouter.presentSettingsAlertForLocationAccess(in: vc)
        }
    }
    
    /// 2
    var locationManagerRequestHandler: AccessStatusHandler = { [weak self] result in
        guard let `self` = self else { return}
        
        switch result {
        case .success:
            locationManager.startUpdatingLocation()
        case .denied:
            self.settingsRouter.presentSettingsAlertForLocationAccess(in: vc)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorization(status: status, for: manager, request: .always, handler: locationManagerRequestHandler) ///locationManagerRequestHandler2
    }
     */
    func handleLocationAuthorization(status: CLAuthorizationStatus, for locationManager: CLLocationManager?, request: LocationRequest, handler: @escaping AccessStatusHandler) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            handler(.success)
        case .denied, .restricted:
            handler(.denied)
        case .notDetermined:
            switch request {
            case .always:
                locationManager?.requestAlwaysAuthorization()
            case .inUse:
                locationManager?.requestWhenInUseAuthorization()
            case .location:
                locationManager?.requestLocation()
            }
        }
    }
    
    
    //----------
    
    func requestContactsAccess(handler: @escaping AccessStatusHandler) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            handler(.success)
        case .denied, .restricted:
            handler(.denied)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                if granted {
                    handler(.success)
                } else {
                    handler(.denied)
                }
            }
        }
    }
    
    /// there is case where can be any error. will be called .denied for it now. maybe will be need additional case for handler
    func requestAcivityAccess(handler: @escaping AccessStatusHandler) {
        
        guard CMMotionActivityManager.isActivityAvailable() else {
            handler(.denied) /// unavailable
            return
        }
        
        /// https://stackoverflow.com/a/35353617
        func requestAccess() {
            let manager = CMMotionActivityManager()
            let now = Date()
            manager.queryActivityStarting(from: now, to: now, to: .main) { _, error in
                if let error = error as NSError? {
                    if error.code == CMErrorMotionActivityNotAuthorized.rawValue {
                        handler(.denied)
                    } else { /// some system error.
                        handler(.denied)
                    }
                } else {
                    handler(.success)
                }
            }

        }
        
        if #available(iOS 11.0, *) {
            switch CMMotionActivityManager.authorizationStatus() {
            case .authorized:
                handler(.success)
            case .denied, .restricted:
                handler(.denied)
            case .notDetermined:
                requestAccess()
            }
        } else {
            requestAccess()
        }
    }
}
