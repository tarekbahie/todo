//
//  ToDoListVC.swift
//  todo
//
//  Created by tarek bahie on 1/26/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListVC: UITableViewController, UISearchBarDelegate {

    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        
        if let item = todoItems?[indexPath.row] {
            cell.todoItemLbl.text = item.title
            cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.651510355, blue: 0.6431372762, alpha: 1)
            cell.todoItemLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            
            cell.accessoryType = item.done ?  .checkmark :  .none
        } else {
            cell.textLabel?.text = "No items added !"
        }
        
        
        
        
        return cell
        
    }
 
// MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
                    tableView.deselectRow(at: indexPath, animated: true)
                    //realm.delete(item)
            }
            } catch {
                print("error saving done status \(error)")
            }
        }
        
        
        
        
        tableView.reloadData()
    }
    
    @IBAction func addNewTodoItemBtnpressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add items", message: "add todo items", preferredStyle: .alert)
        
        alert.addTextField { (itemTextField) in
            itemTextField.placeholder = "create new item"
            textField = itemTextField
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving category : \(error)")
                }
            }

            
            self.tableView.reloadData()
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
    

    func loadItems() {
        
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//
        tableView.reloadData()
}
    
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
