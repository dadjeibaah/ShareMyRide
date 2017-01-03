//
//  DestinationSearchController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 7/11/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//https://github.com/ThornTechPublic/MapKitTutorial/blob/master/MapKitTutorial/ViewController.swift

import Foundation
import UIKit
protocol DisplayMapSearchResult{
    func showPlaceMarkPin(map:MKMapView, placemark:MKPlacemark)
}

protocol ReceiveAnnotationDelegate{
    func populateAnnotation(annotation:MKAnnotation)
}

class DestinationSearchController: UIViewController, CLLocationManagerDelegate, DisplayMapSearchResult,MKMapViewDelegate {
    var destinationSearch:UISearchController!
    var destinationSearchResults:DestinationResultsController!
    var receiveAnnotationDelegate:ReceiveAnnotationDelegate? = nil
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
   
    @IBOutlet weak var searchBarPlaceholder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        askLocationPermission()
        locationManager.delegate = self
        destinationSearchResults = DestinationResultsController()
        destinationSearch = UISearchController(searchResultsController: destinationSearchResults)
        self.searchBarPlaceholder.addSubview(destinationSearch.searchBar)
        destinationSearch.delegate = destinationSearchResults
        destinationSearch.searchResultsUpdater = destinationSearchResults
        destinationSearchResults.mapView = mapView
        destinationSearchResults.showLocationDelegate = self
        destinationSearch.searchBar.sizeToFit()
        destinationSearch.searchBar.autoresizingMask = .FlexibleWidth
        destinationSearch.searchBar.placeholder = "Where to?"
        
        destinationSearch.hidesNavigationBarDuringPresentation = false
        destinationSearch.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        mapView.delegate = self
    }
    
    func askLocationPermission(){
        if CLLocationManager.authorizationStatus() == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else{
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse{
            locationManager.startUpdatingLocation() 
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let locationSpan = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: locationSpan)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func showPlaceMarkPin(map:MKMapView, placemark: MKPlacemark) {
        let annotation: MKDestination
        var cityState:String = ""
        
        map.removeAnnotations(map.annotations)
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            cityState = "\(city) \(state)"
        }
        
        annotation = MKDestination(title: placemark.name!, subtitle:cityState, coordinate: placemark.coordinate)
        map.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        map.setRegion(region, animated: true)
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Destination"
        if annotation is MKDestination{
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if annotationView == nil{
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let button = UIButton(type: .ContactAdd)
                annotationView?.rightCalloutAccessoryView = button
        
            }else{
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        receiveAnnotationDelegate!.populateAnnotation(view.annotation!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func delete(sender: AnyObject?) {
        print("DESTROY!!")
    }
    
    
    
    
    
    
}