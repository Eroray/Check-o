//
//  ViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/4/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var toDoItem : Results<ToDoItem>? //Result Container
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItem?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItem?[indexPath.row] {
            cell.textLabel?.text = item.itemText
            cell.accessoryType = item.doneStatus == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row]{
                try! realm.write {
                    //realm.delete(item)
                    item.doneStatus = !item.doneStatus
                }
            
            //tableView.deleteRows(at: [indexPath], with: .automatic)
           tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add New Items
    
    
    @IBAction func addNewToDo(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Check-o Item", message: "", preferredStyle: .alert)
        
        let addNewAction = UIAlertAction(title: "Add New To Do", style: .default) { (addNewAction) in
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = ToDoItem()
                        newItem.itemText = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.toDoItems.insert(newItem, at: 0)
                    }
                } catch let err {
                    print (err)
                }
            }
            
            self.tableView.reloadData()
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
    
    
    //MARK: - Loading items from Realm Data Base
    
    func loadItems () {
        
        toDoItem = selectedCategory?.toDoItems.sorted(byKeyPath: "itemText", ascending: true)

        tableView.reloadData()
        
        }
}
    




//MARK: - Search Bar Delegate Methods

extension ToDoListViewController : UISearchBarDelegate {

    @objc func tableViewTapped() {

        searchBar.endEditing(true)

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        toDoItem = toDoItem?.filter("itemText CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

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



