//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 15/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.rowHeight = 80.0
 
    }

 

    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray? [indexPath.row].name ?? "No categories added yet"
        
        cell.delegate = self
        
        return cell
    }
    
    
  //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    
    //MARK: Table Manipulation Methods i.e: SaveData() & LoadData()
    
    func save(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
            
        catch{
            print("Error saving category \(error)")
        }
        
        //!!!: Reloading data to load in table view
        self.tableView.reloadData()
        
    }
    
    
    func loadCategory(){
        
        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    

    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        //What we want to happen when user clicks the add button on view to add to category
            
        let newCategory = Category()
        newCategory.name = textField.text!

        self.save(category: newCategory)
            
        }
        
        alert.addAction(action) //Create above
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
    }
        
        
        
        present(alert, animated: true, completion: nil)
    
}
    
}


//MARK: Swipe Table Cell
extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted!")
            
            if let toDelete = self.categoryArray?[indexPath.row]{
                
                do{
                    try self.realm.write{
                        self.realm.delete(toDelete )
                    }
                }
                catch{
                    print("Category could not be deleted! \(error)")
            }
        }
    }

// customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}

