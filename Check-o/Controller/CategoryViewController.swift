//
//  CategoryViewController.swift
//  Check-o
//
//  Created by Ernesto Orihuela on 2/8/19.
//  Copyright © 2019 Ernesto Orihuela. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
         print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
        tableView.register(UINib(nibName: "CustomToDoItemCell", bundle: nil), forCellReuseIdentifier: "CustomToDoItemCell")


    }
        
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomToDoItemCell", for: indexPath) as! CustomToDoItemCell
        let item = categoryArray[indexPath.row]
        
        cell.toDoBodyText?.text = item.categoryName
        cell.toDoBodyText = UILabel(frame: CGRect(x: 16, y: 11, width: 160, height: 21))
        
        return cell
        
    }
    

    //MARK: - Data Source Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }


    //MARK: - Add New Categories
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Check-o Category", message: "", preferredStyle: .alert)
        let addNewCategory = UIAlertAction(title: "Add New Category", style: .default) { (addNewCategory) in
            
            let newItem = Category(context: self.context)
            newItem.categoryName = textField.text!
            self.categoryArray.append(newItem)
            self.saveItems()
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
    
    func saveItems () {
        
        do {
            
            try context.save()
            
        } catch {
            
            print ("Error saving context \(error)")
            
        }
        
        tableView.reloadData() //This method reloads data so the new item from the text field alert is added to the To Do Item Array
    }
    
    func loadItems (with  request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("Error Fetching Data From Context \(error)")
        }
        
        tableView.reloadData()
    }
}
