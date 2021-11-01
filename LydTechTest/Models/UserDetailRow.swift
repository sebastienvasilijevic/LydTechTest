//
//  UserDetailRow.swift
//  LydTechTest
//
//  Created by VASILIJEVIC Sebastien on 01/11/2021.
//

import Foundation

struct UserDetailRow {
    let rowType: RowType
    let value: Any
    
    public enum RowType {
        case image
        case text
        case details
        case map
    }
}
