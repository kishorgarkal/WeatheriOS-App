//
//  MapViewController.swift
//  WeatherApp
//
//  Created by MGB India  on 06/09/20.
//  Copyright © 2020 MGB. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView = MKMapView()
    
    let locationManager = CLLocationManager()
   
    var placemark: CLPlacemark?
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Location"
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mapView)
        
        
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
            
            centreOnUserLoction()
        }
        
        let longTapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleTap(_:)))
        longTapGesture.delegate = self
        longTapGesture.numberOfTapsRequired = 1
        //  view.addGestureRecognizer(longTapGesture)
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    
    
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        self.mapView.removeAnnotations(mapView.annotations)
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        self.sendToNextScreen(location: location)
    }
    
    func centreOnUserLoction() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
           
        }
    }
    func sendToNextScreen(location:CLLocationCoordinate2D){
     
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        vc?.latitude = location.latitude
        vc?.longitude = location.longitude
        self.navigationController?.pushViewController(vc!, animated: true)
       
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
    
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                // control.title = doSomething
                print("do something")
            }
        }
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        let locationInView = gesture.location(in: mapView)
        let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        addAnnotation(location: locationOnMap)
    }
}
