//
//  MapViewController.swift
//  IOSCorner
//
//  Created by Andrey on 12.10.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// This class is created for navigation page.
class MapViewController: UIViewController {
    
    /** This is IBOutlet for mapView*/
    @IBOutlet var mapView: MKMapView!
    /** This is IBOutlet for GO button*/
    @IBOutlet var goButton: UIButton!
    
    let eatCornerAddress = "Шухова, 21"
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 10_000.00
    var placeCoordinate: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupPlaceMark()
        checkLocationServices()
        
    }
    
    /** Call this function for setup place mark. */
    private func setupPlaceMark() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eatCornerAddress) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "EAT CORNER"
            annotation.subtitle = "This is amazing place!"
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    
    /** Call this function to Check the enabled location services on the device.*/
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are Disabled",
                               message: "To enable it go: Settings -> Privacy -> Location services and turn On")
            }
        }
    }
    
    /** Call this function to initially configure LocationManager.*/
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /** Call this function for checking Location Authorization.*/
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your Location is not Available",
                    message: "To give permission Go to: Settings -> IOSCorner -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    /** Call this function for get direction.*/
    private func getDirections() {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found!")
            return
        }
        
        guard let request = createDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found!")
            return
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if let error = error {
                print(error)
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available!")
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                print("Расстояние до места: \(distance) км.")
                print("Время в пути: \(timeInterval) сек.")
            }
        }
        
    }
    
    /** Call this function for creating direction requests.*/
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else {
            return nil
        }
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        return request
    }
    
    /** Call this function for showing alerts.*/
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
    
    /** Call this function for view center user location.*/
    @IBAction func centerViewInUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: regionInMeters,
                longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    /** Call this function when pressed GO button.*/
    @IBAction func goButtonPressed() {
        getDirections()
    }
    
    /** Call this function when pressed CLOSE button.*/
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "ourplace-mansfield-sign")
        annotationView?.rightCalloutAccessoryView = imageView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 1, green: 0.7389854193, blue: 0, alpha: 1)
        
        return renderer
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
