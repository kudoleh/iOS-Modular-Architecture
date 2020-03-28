//
//  CoreDataStorage.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 26/03/2020.
//

import CoreData

public final class CoreDataStorage {

    public static let shared = CoreDataStorage()

    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle(for: Self.self).resource.url(forResource: "CoreDataStorage", withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: modelURL)
            else {
                fatalError("Unable to located Core Data model")
        }
        let container = NSPersistentContainer(name: "Name", managedObjectModel: mom)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support

    public func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
