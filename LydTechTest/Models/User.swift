//
//  User.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 29/10/2021.
//

import Foundation

// MARK: - User
struct User {
    let gender, title, firstName, lastName: String
    let location: Location
    let email: String
    let dob: DateAge
    let registered: DateAge
    let phone, cell: String
    let picture: String
    let nat: String
    
    
    // MARK: - Location
    struct Location {
        let streetNumber: Int
        let streetName: String
        let city, state, country: String
        let postcode: String
        let latitude, longitude: String
        
        init(location: APIUser.Location) {
            streetNumber = location.street.number
            streetName = location.street.name
            city = location.city
            state = location.state
            country = location.country
            postcode = location.postcode.stringValue
            latitude = location.coordinates.latitude
            longitude = location.coordinates.longitude
        }
        
        init(location: CDUserLocation?) {
            streetNumber = location?.streetNumber ?? 0
            streetName = location?.streetName ?? ""
            city = location?.city ?? ""
            state = location?.state ?? ""
            country = location?.country ?? ""
            postcode = location?.postcode ?? ""
            latitude = location?.latitude ?? ""
            longitude = location?.longitude ?? ""
        }
        
        public func getFullAddress() -> String {
            return String(format: "%i %@\n%@ %@\n%@\n%@", streetNumber, streetName, postcode, city, state, country)
        }
    }
    
    // MARK: - DateAge
    struct DateAge {
        let date: String
        let age: Int
        
        init(apiDateAge: APIUser.DateAge) {
            date = apiDateAge.date
            age = apiDateAge.age
        }
        
        init(cdDateAge: CDDateAge?) {
            date = cdDateAge?.date ?? ""
            age = cdDateAge?.age ?? 0
        }
        
        public func getDateWithAge(format: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.DateFormat.utc
            let newDate = dateFormatter.date(from: self.date)
            dateFormatter.dateFormat = format
            
            var dateWithAge: String = ""
            if let newDate = newDate {
                let formattedDate: String = dateFormatter.string(from: newDate)
                dateWithAge += formattedDate + " "
            }
            dateWithAge += "(\(self.age))"
            
            return dateWithAge
        }
    }
    
    // MARK: - Init
    init(apiUser: APIUser) {
        gender = apiUser.gender
        title = apiUser.name.title
        firstName = apiUser.name.first
        lastName = apiUser.name.last
        location = .init(location: apiUser.location)
        email = apiUser.email
        dob = .init(apiDateAge: apiUser.dob)
        registered = .init(apiDateAge: apiUser.registered)
        phone = apiUser.phone
        cell = apiUser.cell
        picture = apiUser.picture.large
        nat = apiUser.nat
    }
    
    init(cdUser: CDUser) {
        gender = cdUser.gender ?? ""
        title = cdUser.title ?? ""
        firstName = cdUser.firstName ?? ""
        lastName = cdUser.lastName ?? ""
        location = .init(location: cdUser.location)
        email = cdUser.email ?? ""
        dob = .init(cdDateAge: cdUser.dob)
        registered = .init(cdDateAge: cdUser.registered)
        phone = cdUser.phone ?? ""
        cell = cdUser.cell ?? ""
        picture = cdUser.picture ?? ""
        nat = cdUser.nat ?? ""
    }
    
    
    // MARK: - Methods
    public func getFullName(showTitle: Bool) -> String {
        return (showTitle ? title + " " : "") + firstName + " " + lastName
    }
    
    public func getFlagNameAge(showTitle: Bool, showAge: Bool) -> String {
        let flag: String = self.nat.flag()
        let name: String = self.getFullName(showTitle: showTitle)
        let age: String = " (\(self.dob.age))"
        return flag + " " + name + (showAge ? age : "")
    }
}
