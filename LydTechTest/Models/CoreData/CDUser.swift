//
//  CDUser.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 28/10/2021.
//

import Foundation
import CoreData

class CDUser: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, user: User) {
        self.init(context: context)
        
        gender = user.gender
        title = user.title
        firstName = user.firstName
        lastName = user.lastName
        location = .init(location: user.location)
        email = user.email
        dob = .init(dateAge: user.dob)
        registered = .init(dateAge: user.registered)
        phone = user.phone
        cell = user.cell
        picture = user.picture
        nat = user.nat
    }
}
