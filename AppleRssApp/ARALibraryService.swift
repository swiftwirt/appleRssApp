//
//  ARALibraryService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import CoreData
import UIKit

let MyManagedObjectContextSaveDidFailNotification = "MyManagedObjectContextSaveDidFailNotification"

    func fatalCoreDataError(error: Error)
    {
        print("*** Fatal error: \(error)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MyManagedObjectContextSaveDidFailNotification), object: nil)
    }

class ARALibraryService {
    
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "RssItem", in: managedObjectContext)
        let sortDescriptor = NSSortDescriptor(key: "pubDate", ascending: true)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "pubDate", cacheName: nil)
    }
    
    func updateLibraryWith(_ dictionary: [String: Any])
    {
        let predicate = NSPredicate(format: "title == %@", dictionary["title"] as! String)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "RssItem", in: managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as! [RssItem]
            if result.count == 0 {
                let item = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! RssItem
                // TODO: - replace literals with structs
                item.title = dictionary["title"] as! String?
                item.content = dictionary["content"] as! String?
                item.pubDate = dictionary["pubDate"] as! String?
                item.link = dictionary["link"] as! String?
                    do {
                        try managedObjectContext.save()
                    } catch {
                        fatalError()
                    }
                }
            } catch {
                fatalError()
            }
    }
    
    //MARK: - Core Data Stack
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Could not find data model in app bundle")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing model from: \(modelURL)")
        }
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        let storeURL = documentsDirectory.appendingPathComponent("AppleRssApp.sqlite")
        print(storeURL)
        
        do {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        } catch {
            fatalError("Error adding persistent store at \(storeURL): \(error)")
        }
    }()
    
    //MARK: - Defencive notification for urgent data base crash tracking
    func listenForFatalCoreDataNotifications()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: MyManagedObjectContextSaveDidFailNotification), object: nil, queue: OperationQueue.main, using: { notification in
            let alert = UIAlertController(title: "Internal Error",
                                          message: "There was a fatal error in the app and it cannot continue.\n\n"
                                            + "Press OK to terminate the app. Sorry for the inconvenience.",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            self.viewControllerForShowingAlert().present(
                alert, animated: true, completion: nil)
        })
    }
    
    func viewControllerForShowingAlert() -> UIViewController
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return UIViewController()}
        let rootViewController = appDelegate.window!.rootViewController!
        if let presentedViewController = rootViewController.presentedViewController {
            return presentedViewController
        } else {
            return rootViewController
        }
    }

}
