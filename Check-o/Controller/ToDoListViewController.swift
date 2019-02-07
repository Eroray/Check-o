//
//  ViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/4/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var toDoItemArray = [ToDoItem]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newToDoItem = ToDoItem()
        newToDoItem.itemText = "Buy Eggs"
        toDoItemArray.append(newToDoItem)
        
        let newToDoItem1 = ToDoItem()
        newToDoItem1.itemText = "Buy Ham"
        toDoItemArray.append(newToDoItem1)
        
        let newToDoItem2 = ToDoItem()
        newToDoItem2.itemText = "Go to the GYM"
        toDoItemArray.append(newToDoItem2)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: "CustomToDoItemCell", bundle: nil), forCellReuseIdentifier: "CustomToDoItemCell")
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomToDoItemCell", for: indexPath) as! CustomToDoItemCell
        
        let item = toDoItemArray[indexPath.row]
        
        cell.toDoBodyText?.text = item.itemText
        
        cell.toDoBodyText = UILabel(frame: CGRect(x: 16, y: 11, width: 160, height: 21))
        
        cell.accessoryType = item.doneStatus == true ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoItemArray[indexPath.row])
        
        toDoItemArray[indexPath.row].doneStatus = !toDoItemArray[indexPath.row].doneStatus
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    
    
    @IBAction func addNewToDo(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Check-o Item", message: "", preferredStyle: .alert)
        
        let addNewAction = UIAlertAction(title: "Add New To Do", style: .default) { (addNewAction) in
            
            let newItem = ToDoItem()
            
            newItem.itemText = textField.text!
        
            self.toDoItemArray.append(newItem)
            
            self.tableView.reloadData() //This method reloads data so the new item from the text field alert is added to the To Do Item Array
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Start Typing Your New To Do"
            textField = alertTextField //Extending the scope of the alert Text Field
            
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(addNewAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    
}

