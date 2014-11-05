//
//  ViewController.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/4/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Long Press Gesture Recognizer on Map View
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        mapView.addGestureRecognizer(longPress)
        
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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

    // MARK: - GESTURE RECOGNIZER
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        //println("Map Long Pressed.")
        
        // Placing Map Pin on Map
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            println("\(touchCoordinate.latitude) \(touchCoordinate.longitude)")
            
            // Creating Map Annotation
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Add Reminder"
            self.mapView.addAnnotation(annotation)
        }
    }

}

