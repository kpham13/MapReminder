//
//  ViewController.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/4/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Long Press Gesture Recognizer on Map View
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        mapView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - GESTURE RECOGNIZER
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        println("Map Long Pressed.")
    }

}

