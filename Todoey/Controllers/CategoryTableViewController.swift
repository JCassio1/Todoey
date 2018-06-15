//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 15/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var categoryArray = [Category]() // the parethesis in the array are used to initialise the array
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Used for CRUD
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
        
        print("The dataFilePath is: \(dataFilePath)")
        
        loadCategory()

    }

 

    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
  //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    
    //MARK: Table Manipulation Methods i.e: SaveData() & LoadData()
    
    func saveCategory() {
        
        let encoder = PropertyListEncoder()
        
        do{
            try context.save()
        }
            
        catch{
            print("Error saving context \(error)")
        }
        
        //!!!: Reloading data to load in table view
        self.tableView.reloadData()
        
    }
    
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        
        do{
            categoryArray = try context.fetch(request)
        }
            
        catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    

    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        //What we want to happen when user clicks the add button on view to add to category
            
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categoryArray.append(newCategory)
        self.saveCategory()
        }
        
        alert.addAction(action) //Create above
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
    }
        
        
        
        present(alert, animated: true, completion: nil)
    
}
    
    

    
    
}
