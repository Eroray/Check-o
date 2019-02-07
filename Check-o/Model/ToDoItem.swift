//
//  ToDoItem.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/6/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import Foundation

class ToDoItem : Decodable, Encodable {
    
    var itemText : String = ""
    
    var doneStatus : Bool = false
    
    
}
