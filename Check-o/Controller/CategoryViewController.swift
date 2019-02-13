//
//  CategoryViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/8/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        

        loadCategories()
        
        tableView.separatorStyle = .none

    }
        
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        let item = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = item?.categoryName ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor.randomFlat
        
        return cell
        
    }
    

    //MARK: - Data Source Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryArray?[indexPath.row] != nil{
            try! realm.write {
                performSegue(withIdentifier: "goToItems", sender: self)
                print(categoryArray![indexPath.row])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
        
    }


    //MARK: - Add New Categories
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Check-o Category", message: "", preferredStyle: .alert)
        let addNewCategory = UIAlertAction(title: "Add New Category", style: .default) { (addNewCategory) in
            
            let newCategory = Category()
            newCategory.categoryName = textField.text!
            newCategory.dateCreated = Date()
            self.saveItems(category: newCategory)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Start Typing Your New Category"
            textField = alertTextField
            
        }
        
        alert.addAction(addNewCategory)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - TableView Manipulation Methods
    
    func saveItems (category : Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch let err {
            
            print (err)
            
        }
        
        tableView.reloadData() //This method reloads data so the new item from the text field alert is added to the To Do Item Array
    }
    
   func loadCategories () {
    
            categoryArray = realm.objects(Category.self).sorted(byKeyPath: "categoryName", ascending: true)
            tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModle(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            try! self.realm.write {
                 self.realm.delete(categoryForDeletion)
            }
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    } 
}


extension CategoryViewController : UISearchBarDelegate {
    
    @objc func tableViewTapped () {
        
        searchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categoryArray = categoryArray?.filter("categoryName CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadCategories()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
        }
    }
}



