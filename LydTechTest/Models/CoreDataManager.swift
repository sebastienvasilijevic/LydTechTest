//
//  CoreDataManager.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import CoreData
import UIKit

class CoreDataManager {
    static var persistentContainer: NSPersistentContainer? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return delegate.persistentContainer
    }
    
    static func addUser(user: User?) {
        guard let user = user,
              let persistentContainer = CoreDataManager.persistentContainer else {
            return
        }
        
        let context = persistentContainer.viewContext
        
        let _ = CDUser(context: context, user: user)
        
        try? context.save()
    }
    
    static func getSavedUsers() -> [CDUser] {
        guard let persistentContainer = CoreDataManager.persistentContainer else {
            return .init()
        }
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        
        let objects = try? context.fetch(fetchRequest)
        
        return objects ?? []
    }
    
    static func deleteAllUsers() {
        guard let persistentContainer = CoreDataManager.persistentContainer else {
            return
        }
        
        let context = persistentContainer.viewContext
        
        let savedUsers: [CDUser] = CoreDataManager.getSavedUsers()
        
        for user in savedUsers {
            context.delete(user)
        }
        
        try? context.save()
    }
}
