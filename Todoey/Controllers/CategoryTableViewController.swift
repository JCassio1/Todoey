//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 15/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
    }

 
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categorycolour = UIColor(hexString : category.cellColor) else{fatalError()}
            
            cell.backgroundColor = categorycolour
            cell.textLabel?.textColor = ContrastColorOf(categorycolour, returnFlat: true)
        }

        
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
        tableView.reloadData()
        
    }
    
    
    func loadCategory(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let toDelete = self.categoryArray?[indexPath.row]{

            do{
                try self.realm.write{
                    self.realm.delete(toDelete)
                }
            }
            catch{
                print("Category could not be deleted, \(error)")
            }
        }
    }
    
    
    

    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        let newCategory = Category()
        newCategory.name = textField.text!
        newCategory.cellColor = UIColor.randomFlat.hexValue()

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



