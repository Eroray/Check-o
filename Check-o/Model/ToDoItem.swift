//
//  ToDoItem.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/11/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem : Object {
    
    @objc dynamic var itemText : String = ""
    @objc dynamic var doneStatus : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "toDoItems") //Inverse relationshiop of the ToDoItems
    
}
