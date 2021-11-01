//
//  CDDateAge.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import Foundation

class CDDateAge: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    public var date: String?
    public var age: Int?
    
    enum Key: String {
        case date = "date"
        case age = "age"
    }
    
    init(date: String?, age: Int?) {
        self.date = date
        self.age = age
    }
    
    init(dateAge: User.DateAge) {
        self.date = dateAge.date
        self.age = dateAge.age
    }
    
    required convenience init?(coder: NSCoder) {
        let decodedDate = coder.decodeObject(forKey: Key.date.rawValue) as? String
        let decodedAge = coder.decodeObject(forKey: Key.age.rawValue) as? Int
        
        self.init(date: decodedDate, age: decodedAge)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: Key.date.rawValue)
        coder.encode(age, forKey: Key.age.rawValue)
    }
}

// MARK: - DataTransformer
@objc(DateAgeAttributeTransformer)
class DateAgeAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [CDDateAge.self]
    }
    
    static func register() {
        let className = String(describing: DateAgeAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer: DateAgeAttributeTransformer = .init()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
