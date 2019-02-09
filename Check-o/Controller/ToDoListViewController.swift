//
//  ViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/4/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var toDoItemArray = [ToDoItem]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        loadItems(with : request)
        
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
    
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
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoItemArray[indexPath.row])
        
        //context.delete(toDoItemArray[indexPath.row])
        //toDoItemArray.remove(at: indexPath.row)
        
        toDoItemArray[indexPath.row].doneStatus = !toDoItemArray[indexPath.row].doneStatus
        
        self.saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }

//MARK: - Add New Items
    
    
    @IBAction func addNewToDo(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Check-o Item", message: "", preferredStyle: .alert)
        
        let addNewAction = UIAlertAction(title: "Add New To Do", style: .default) { (addNewAction) in
            
            let newItem = ToDoItem(context: self.context)
            
            newItem.itemText = textField.text!
            
            newItem.doneStatus = false
        
            self.toDoItemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Start Typing Your New To Do"
            textField = alertTextField //Extending the scope of the alert Text Field
            
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(addNewAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
//MARK: - Creating & Reading Core Data
    
    
    func saveItems () {
    
        do {
            
            try context.save()
            
        } catch {
            
            print ("Error saving context \(error)")
            
        }
        
        tableView.reloadData() //This method reloads data so the new item from the text field alert is added to the To Do Item Array
    }
    
    func loadItems (with  request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest() ) {
        
        do {
            toDoItemArray = try context.fetch(request)
        } catch {
            print ("Error Fetching Data From Context \(error)")
        }
        
        tableView.reloadData()
     }
}


//MARK: - Search Bar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    @objc func tableViewTapped() {
        
        searchBar.endEditing(true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest = ToDoItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "itemText CONTAINS [cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "itemText", ascending: true)]
        
        loadItems(with : request)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
        }
    }
}



