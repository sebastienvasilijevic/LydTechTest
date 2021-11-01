//
//  WebServices.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 27/10/2021.
//

import Foundation

class WebServices {
    static func loadUsers(count: Int, completion: @escaping ([User]?, Bool?) -> Void) {
        NetworkManager.getUsers(count: count) { apiUsers, error in
            guard error == nil else {
                completion(nil, false)
                return
            }
            
            var users: [User] = []
            apiUsers?.results.forEach { apiUser in
                users.append(.init(apiUser: apiUser))
            }
            
            completion(users, true)
        }
    }
}
