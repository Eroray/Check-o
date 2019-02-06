//
//  ViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/4/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var toDoItemArray = ["Buy Eggs","Buy Ham","Go to the GYM"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: "CustomToDoItemCell", bundle: nil), forCellReuseIdentifier: "CustomToDoItemCell")
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomToDoItemCell", for: indexPath) as! CustomToDoItemCell
        cell.toDoBodyText?.text = toDoItemArray[indexPath.row]
        cell.toDoBodyText = UILabel(frame: CGRect(x: 16, y: 11, width: 160, height: 21))
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoItemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    
    
    @IBAction func addNewToDo(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Check-o Item", message: "", preferredStyle: .alert)
        
        let addNewAction = UIAlertAction(title: "Add New To Do", style: .default) { (addNewAction) in
            
           
            self.toDoItemArray.append(textField.text!)
            
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

