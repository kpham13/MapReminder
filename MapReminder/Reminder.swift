//
//  Reminder.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/7/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate
    @NSManaged var radius: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
