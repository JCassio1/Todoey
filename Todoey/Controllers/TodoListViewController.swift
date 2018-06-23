//
//  ViewController.swift
//  Todoey
//
//  Created by MR.Robot 💀 on 13/06/2018.
//  Copyright © 2018 Joselson Dias. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    

    var realm = try! Realm()
    var todoItems: Results<Item>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{
             loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none

        }

    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist!")}
        
        guard let colourHex = selectedCategory?.cellColor else {fatalError("color property of category does not exist")}
                    
            title = selectedCategory?.name //updates items navigation title

            
        guard let navBarColour = UIColor(hexString: colourHex) else{fatalError("Problem with navBarColour")}
                    
                        navBar.barTintColor = navBarColour
                        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                        searchBar.barTintColor = navBarColour
                        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
}
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else{fatalError("Original colour did not pass")}
        navigationController?.navigationBar.barTintColor = originalColour
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(FlatWhite(), returnFlat: true)]
    }
    




    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = todoItems? [indexPath.row].title ?? "No Items added yet"
            
            
            if let colour = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            
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
//                    item.done = !item.done
                    realm.delete(item)
                }
                
            }
            
            catch{
                print("Error updating row \(error)")
            }
        }
        
        tableView.reloadData()
        
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
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
            }
                catch{
                    print("Error saving new items \(error)")
                }
                self.tableView.reloadData()
        }
            
            
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
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
            
            do{
                try self.realm.write{
                    self.realm.delete(item)
                }
            }
            catch{
                print("Category could not be deleted! \(error)")
            }
        }
    }
    
 
}

//Mark: UI SearchBar method

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.sync {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}

