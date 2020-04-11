//
//  BusinessLogic.swift
//  iTunesBrowser
//
//  Created by Artem Mkrtchyan on 4/11/20.
//  Copyright © 2020 Artem Mkrtchyan. All rights reserved.
//

import CoreData
import iTunesApi
import UIKit

class BusinessLogic {
    
    static let shared = BusinessLogic()
    private init() {}
    
    private let dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func isInFav(_ item: iTunesItem) -> Bool {
        guard let id = item.artistID else {
            return false
        }
        
        return getResultsFor(id).first != nil
        

    }
    
    func fetchItems() -> [iTunesItem] {
        var list:[iTunesItem] = []
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        var results: [NSManagedObject] = []
        do {
            results = try dbContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        for item in results {
            if let data = item.value(forKey: "data") as? Data,
                let iTunesItem = try? JSONDecoder().decode(iTunesItem.self, from: data){
                list.append(iTunesItem)
            }
        }
    
        return list
    }
    
    
    func setFavState(_ state: Bool, item: iTunesItem) {
        guard let id = item.artistID else {
            return
        }
        
        let results = getResultsFor(id)
        
        if state {
            addToFav(results: results, item: item)
        } else {
            removeFromFav(results: results)
        }
    }
    
    private func removeFromFav(results: [NSManagedObject]) {
        
        
        if let managedObject = results.first {
            dbContext.delete(managedObject)
        }
    }
    
    private func addToFav(results: [NSManagedObject], item: iTunesItem) {
        
        if let data = try? JSONEncoder().encode(item),  results.count < 1 {
            
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: dbContext)!
            let _object = NSManagedObject(entity: entity, insertInto: dbContext)
            _object.setValue("\(item.artistID!)", forKeyPath: "id")
            _object.setValue(data, forKey: "data")
            
            do {
                try dbContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    private func getResultsFor(_ id: Int) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        var results: [NSManagedObject] = []
        do {
            results = try dbContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results
    }
}
