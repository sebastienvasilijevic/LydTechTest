//
//  APIUser.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 27/10/2021.
//

import Foundation

// MARK: - APIUsers
struct APIUsers: Codable {
    let results: [APIUser]
}

// MARK: - APIUser
struct APIUser: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: DateAge
    let registered: DateAge
    let phone, cell: String
    let picture: Picture
    let nat: String
    
    
    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }
    
    // MARK: - Location
    struct Location: Codable {
        let street: Street
        let city, state, country: String
        let postcode: Postcode
        let coordinates: Coordinates
        
        
        // MARK: - Street
        struct Street: Codable {
            let number: Int
            let name: String
        }
        
        // MARK: - Coordinates
        struct Coordinates: Codable {
            let latitude, longitude: String
        }
        
        // MARK: - Postcode
        enum Postcode: Codable {
            case integer(Int)
            case string(String)
            
            var stringValue: String {
                switch self {
                case .integer(let value):
                    return "\(value)"
                case .string(let value):
                    return value
                }
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let x = try? container.decode(Int.self) {
                    self = .integer(x)
                    return
                }
                if let x = try? container.decode(String.self) {
                    self = .string(x)
                    return
                }
                throw DecodingError.typeMismatch(Postcode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
            }

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .integer(let x):
                    try container.encode(x)
                case .string(let x):
                    try container.encode(x)
                }
            }
        }
    }
    
    // MARK: - DateAge
    struct DateAge: Codable {
        let date: String
        let age: Int
    }
    
    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}
