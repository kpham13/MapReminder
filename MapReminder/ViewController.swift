//
//  ViewController.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/4/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var currentAnnotation : MKAnnotation?
    var currentRegion : CLCircularRegion?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("CLAuthorizationStatus: Authorized")
            //self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("CLAuthorizationStatus: Not Determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("CLAuthorizationStatus: Restricted")
        case .Denied:
            println("CLAuthorizationStatus: Denied")
        default:
            println("CLAuthorizationStatus: Default")
        }
        
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if currentRegion != nil {
            // Dismisses Callout of Current Annotation
            mapView.deselectAnnotation(currentAnnotation, animated: true)
            
            // Zoom Animation of Current Region
            let regionView = MKCoordinateRegionMakeWithDistance(currentRegion!.center, 4000, 4000)
            var coordinateRegion = MKCoordinateRegion(center: currentRegion!.center, span: regionView.span)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // ?
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - MAP KIT
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // Configure Map Annotations
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        
        return annotationView
    }
    
    func reminderAdded(notification: NSNotification) {
        // Add Region Overlay to Map View
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        mapView.addOverlay(overlay)
        
        // Setting up Zoom Effect of Current Region
        currentRegion = geoRegion
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        // Customize Region Overlay
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.20)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 0.5
        //renderer.lineDashPattern = [1,3]
        return renderer
    }
    
    // MARK: - CORE LOCATION
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("Changed to Authorized")
            //self.locationManager.startUpdatingLocation()
        default:
            println("Default on Authorization Change")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entering Region...")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Leaving Region...")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("We got a location update!")
        
        if let location = locations.last as? CLLocation {
            println(" \(location.coordinate.latitude)")
        }
    }

    // MARK: - GESTURE RECOGNIZER
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        // Placing Map Pin on Map
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(mapView)
            let touchCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            println("Lat: \(touchCoordinate.latitude), Long: \(touchCoordinate.longitude)")
            
            // Creating Map Annotation
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Add Reminder"
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: - NAVIGATION
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // Segue to Add Reminder View Controller
        let addReminderVC = storyboard?.instantiateViewControllerWithIdentifier("ADD_REMINDER_VC") as AddReminderViewController
        addReminderVC.locationManager = locationManager
        addReminderVC.selectedAnnotation = view.annotation
        currentAnnotation = view.annotation
        presentViewController(addReminderVC, animated: true, completion: nil)
    }
    
    // MARK: - VIEW DID LOAD
    
    func setupVC() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reminderAdded:", name: "REMINDER_ADDED", object: nil)
        
        // Long Press Gesture Recognizer on Map View
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        mapView.addGestureRecognizer(longPress)
    }

}

