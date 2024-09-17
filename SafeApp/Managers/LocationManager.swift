import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var placeName: String?

    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.location = newLocation
        
        // Print the location coordinates
        print("Current location: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
        // Reverse geocoding to get place name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                self?.placeName = "Unknown location"
                return
            }
            
            guard let placemark = placemarks?.first else {
                self?.placeName = "Unknown location"
                return
            }
            
            let name = placemark.name ?? "Unknown place"
            let locality = placemark.locality ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            
            // Combine different address components if needed
            self?.placeName = "\(name), \(locality), \(administrativeArea)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.placeName = "Location unavailable"
    }
}
