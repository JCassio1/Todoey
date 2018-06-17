//
//  ViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 13/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    

    var realm = try! Realm()
    var todoItems: Results<Item>?
    
    
    var selectedCategory : Category? {
        didSet{
             loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
            }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = todoItems? [indexPath.row].title ?? "No Items added yet"
            
            cell.accessoryType = item.done == true ? .checkmark : .none //replaced if/else
        }
        
        else{
            cell.textLabel?.text = "No items added"
        }

        
        


        return cell
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                
                try realm.write{
                    item.done = !item.done
                }
                
            }
            
            catch{
                print("Error updating row \(error)")
            }
        }
        

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    }
            }
                catch{
                    print("Error saving new items \(error)")
                }

        }
            
            self.tableView.reloadData()
        }
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new action"
            textField = alertTextField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Model Manipulation methods
//    func saveItems() {
//
//        let encoder = PropertyListEncoder()
//
//        do{
//            try context.save()
//        }
//
//        catch{
//            print("Error saving context \(error)")
//        }
//
//
//
//        //!!!: Reloading data to load in table view
//        self.tableView.reloadData()
//    }
    
    func loadItems() {
        
        //itemArray = selectedCategory?.items.sorted(byKeyPath: "Items", ascending: true)
        
        tableView.reloadData()
    }
    
 
}

//Mark: UI SearchBar method


