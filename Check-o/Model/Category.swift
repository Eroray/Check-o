//
//  Category.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/11/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var categoryName : String = ""
    @objc dynamic var dateCreated : Date?
    let toDoItems = List<ToDoItem>() // This variable is gonna contain a list of ToDoItems initialize with empty array, Forward relationship that point to a list of items objects.
    
    
}
