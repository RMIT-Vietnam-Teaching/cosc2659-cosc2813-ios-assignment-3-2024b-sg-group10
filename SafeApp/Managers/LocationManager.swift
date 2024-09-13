import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()
    
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var placeName: String? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation
            reverseGeocode(location: newLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                self?.placeName = nil
                return
            }
            if let placemark = placemarks?.first {
                self?.placeName = placemark.name ?? "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
            }
        }
    }
}
