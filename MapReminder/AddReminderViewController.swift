//
//  AddReminderViewController.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/4/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddReminderViewController: UIViewController, MKMapViewDelegate {
    
    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    let regionRadius : CLLocationDistance = 1600
    var managedObjectContext : NSManagedObjectContext!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        //let regionSet = self.locationManager.monitoredRegions
        //let regions = regionSet.allObjects
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // Zoom Animation of Proposed Region View
        let regionView = MKCoordinateRegionMakeWithDistance(selectedAnnotation.coordinate, 4000, 4000)
        var coordinateRegion = MKCoordinateRegion(center: selectedAnnotation.coordinate, span: regionView.span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addReminderButton(sender: AnyObject) {
        // Creates Region around Annotation Coordinate
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: regionRadius, identifier: "ReminderRegion")
        locationManager.startMonitoringForRegion(geoRegion)
        println("Region added and started monitoring region")

        // Insert Reminder into Database, utilizing Reminder model
        var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: managedObjectContext) as Reminder
        newReminder.name = reminderTextField.text
        newReminder.date = NSDate()
        newReminder.radius = regionRadius
        newReminder.latitude = selectedAnnotation.coordinate.latitude
        newReminder.longitude = selectedAnnotation.coordinate.longitude
        
        // Saving Changes
        var error : NSError?
        managedObjectContext.save(&error)
        
        // Error Checking
        if error != nil {
            println(error?.localizedDescription)
        }
        
        // Posts to Notification Center
        NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region" : geoRegion])
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - MAP KIT
    
    func setupMapView() {
        // Creating Map Annotation
        var annotation = MKPointAnnotation()
        annotation.coordinate = selectedAnnotation.coordinate
        mapView.addAnnotation(annotation)
        
        // Creating Proposed Region Overlay
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: regionRadius, identifier: "ReminderRegion")
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        mapView.addOverlay(overlay)
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
    
    // MARK: - VIEW DID LOAD
    
    func setupVC() {
        
    }
    
}