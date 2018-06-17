//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 15/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
 
    }

 

    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray? [indexPath.row].name ?? "No categories added yet"
        
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

