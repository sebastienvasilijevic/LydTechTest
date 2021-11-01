//
//  Network.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 27/10/2021.
//

import Foundation
import UIKit

class NetworkManager {
    static func getApi<Model: Decodable>(uri: String, completion: @escaping (Model?, Error?) -> ()) {
        guard let url = URL(string: uri) else {
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            DispatchQueue.main.async {
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    
                    do {
                        let data = try jsonDecoder.decode(Model.self, from: data)
                        
                        completion(data, nil)
                        
                    } catch let error {
                        completion(nil, error)
                    }
                    
                } else if let error = error {
                    completion(nil, error)
                }
            }
            
        }.resume()
    }
    
    static func getUsers(count: Int, completion: @escaping (APIUsers?, Error?) -> ()) {
        self.getApi(uri: Constants.API.users + "?results=\(count)", completion: completion)
    }
}
