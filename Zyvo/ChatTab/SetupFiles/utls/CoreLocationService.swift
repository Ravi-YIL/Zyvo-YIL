// https://developer.apple.com/documentation/corelocation/cllocationmanager

protocol CoreLocationServiceDelegate: class {
    func didSuccessToGetPostalCodeOfCurrent(postalcode: String,location : CLLocation)
    func didFailureToGetPostalCodeOfCurrent(error: Error)
}
import Foundation
import CoreLocation

class CoreLocationService: NSObject, CLLocationManagerDelegate {
    private lazy var manager: CLLocationManager = CLLocationManager()
    var delegate: CoreLocationServiceDelegate?

    func canLoadLocation() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .authorizedWhenInUse, .authorizedAlways:
            return true
        case .denied, .restricted:
            return false
        @unknown default:
            fatalError("s")
        }
    }

    private func callErrorWithMessage(message: String) {
        let error = NSError(domain: "sample.geolocation.location", code: -1000, userInfo: ["message": message])
        self.delegate?.didFailureToGetPostalCodeOfCurrent(error: error)
    }

    private func requestLocating() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.callErrorWithMessage(message: "You cannot get corelocation.")
            return
        }

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.manager.requestLocation()
        case .denied, .restricted, .notDetermined:
            self.callErrorWithMessage(message: "You cannot get corelocation.")
        @unknown default:
            fatalError("a")
        }
    }

    private func startLocating() {
        guard CLLocationManager.locationServicesEnabled() else {
            self.callErrorWithMessage(message: "You cannot get corelocation.")
            return
        }

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            self.manager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            self.callErrorWithMessage(message: "You cannot get corelocation.")
        @unknown default:
            fatalError("a")
        }
    }

    private func stopLocating() {
        self.manager.stopUpdatingLocation()
    }

    func configurePer() {
        self.manager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }
    }
    func configure() {
        self.manager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
            return
        }else{
        self.requestLocating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.requestLocating()
            return
        }

        self.callErrorWithMessage(message: "Please authorize permission of location.")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            CLGeocoder().reverseGeocodeLocation(location) { (_placemarks, _error) in

                if let error = _error {
//                    self.delegate?.didFailureToGetPostalCodeOfCurrent(error: error)
                    return
                }

                guard let placemark = _placemarks?.first, let postalcode = placemark.compactAddress else {
                    self.callErrorWithMessage(message: "You failed getting location.")
                    return
                }

                self.delegate?.didSuccessToGetPostalCodeOfCurrent(postalcode: postalcode, location: location)
                self.stopLocating()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating " + error.localizedDescription)
    }
}

class CoreLocationReceiver: CoreLocationServiceDelegate {
    func didSuccessToGetPostalCodeOfCurrent(postalcode: String, location: CLLocation) {
        print(postalcode)
    }
    

    func didFailureToGetPostalCodeOfCurrent(error: Error) {
        let nserror = (error as Error)
        print(nserror.localizedDescription)
    }
}

//let service = CoreLocationService()
//let serviceReceiver = CoreLocationReceiver()
//service.delegate = serviceReceiver
//service.configure()
extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
