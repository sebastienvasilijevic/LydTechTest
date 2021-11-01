//
//  CDUserLocation.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 30/10/2021.
//

import Foundation

class CDUserLocation: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    public var streetNumber: Int?
    public var streetName: String?
    public var city, state, country: String?
    public var postcode: String?
    public var latitude, longitude: String?
    
    enum Key: String {
        case streetNumber = "streetNumber"
        case streetName = "streetName"
        case city = "city"
        case state = "state"
        case country = "country"
        case postcode = "postcode"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(streetNumber: Int?, streetName: String?, city: String?, state: String?, country: String?, postcode: String?, latitude: String?, longitude: String?) {
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.city = city
        self.state = state
        self.country = country
        self.postcode = postcode
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    init(location: User.Location) {
        self.streetNumber = location.streetNumber
        self.streetName = location.streetName
        self.city = location.city
        self.state = location.state
        self.country = location.country
        self.postcode = location.postcode
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
    
    required convenience init?(coder: NSCoder) {
        let decodedStreetNumber = coder.decodeObject(forKey: Key.streetNumber.rawValue) as? Int
        let decodedStreetName = coder.decodeObject(forKey: Key.streetName.rawValue) as? String
        let decodedCity = coder.decodeObject(forKey: Key.city.rawValue) as? String
        let decodedState = coder.decodeObject(forKey: Key.state.rawValue) as? String
        let decodedCountry = coder.decodeObject(forKey: Key.country.rawValue) as? String
        let decodedPostcode = coder.decodeObject(forKey: Key.postcode.rawValue) as? String
        let decodedLatitude = coder.decodeObject(forKey: Key.latitude.rawValue) as? String
        let decodedLongitude = coder.decodeObject(forKey: Key.longitude.rawValue) as? String
        
        self.init(streetNumber: decodedStreetNumber, streetName: decodedStreetName, city: decodedCity, state: decodedState, country: decodedCountry, postcode: decodedPostcode, latitude: decodedLatitude, longitude: decodedLongitude)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(streetNumber, forKey: Key.streetNumber.rawValue)
        coder.encode(streetName, forKey: Key.streetName.rawValue)
        coder.encode(city, forKey: Key.city.rawValue)
        coder.encode(state, forKey: Key.state.rawValue)
        coder.encode(country, forKey: Key.country.rawValue)
        coder.encode(postcode, forKey: Key.postcode.rawValue)
        coder.encode(latitude, forKey: Key.latitude.rawValue)
        coder.encode(longitude, forKey: Key.longitude.rawValue)
    }
}

// MARK: - DataTransformer
@objc(UserLocationAttributeTransformer)
class UserLocationAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [CDUserLocation.self]
    }
    
    static func register() {
        let className = String(describing: UserLocationAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer: UserLocationAttributeTransformer = .init()
        
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
