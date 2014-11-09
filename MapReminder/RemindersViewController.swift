//
//  RemindersViewController.swift
//  MapReminder
//
//  Created by Kevin Pham on 11/7/14.
//  Copyright (c) 2014 Kevin Pham. All rights reserved.
//

import UIKit
import CoreData

class RemindersViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDelegate.managedObjectContext

        // Add Notification Center Observer for iCloud Changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        // Delete All Core Data Caches (Required to fix Core Data fatal error)
        NSFetchedResultsController.deleteCacheWithName(nil)

        // Setup Fetched Results Controller
        var fetchRequest = NSFetchRequest(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: "Reminders")
        
        var error : NSError?
        if fetchedResultsController.performFetch(&error) == false {
            println(error!)
        }
        
        tableView.dataSource = self
        fetchedResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override init() {
//        var fetchRequest = NSFetchRequest(entityName: "Reminder")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//    }
    
//    init(fetchRequest fetchRequest: NSFetchRequest,
//        managedObjectContext context: NSManagedObjectContext,
//        sectionNameKeyPath sectionNameKeyPath: String?,
//        cacheName name: String?)
    
//    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    // MARK: - TABLE VIEW DATA SOURCE
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TABLEVIEW_CELL", forIndexPath: indexPath) as UITableViewCell
        
        let reminder = fetchedResultsController.fetchedObjects?[indexPath.row] as Reminder
        cell.textLabel.text = reminder.name
        
        return cell
    }

    // MARK: - FETCHED RESULTS CONTROLLER DELEGATE
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - CLOUD
    
    func didGetCloudChanges(notification: NSNotification) {
        //managedObjectContext.performBlock { () -> Void in
            managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        //}
    }
    
}
