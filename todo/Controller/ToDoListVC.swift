//
//  ToDoListVC.swift
//  todo
//
//  Created by tarek bahie on 1/26/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController, UISearchBarDelegate {

    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        
        let item = itemArray[indexPath.row]
        cell.todoItemLbl.text = item.title
        cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.651510355, blue: 0.6431372762, alpha: 1)
        cell.todoItemLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        cell.accessoryType = item.done ?  .checkmark :  .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
        
    }
 
// MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
        
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
            tableView.deselectRow(at: indexPath, animated: true)
        
            saveItems()
//        if itemArray[indexPath.row].done == true {
//            itemArray[indexPath.row].done = false
//        } else {
//            itemArray[indexPath.row].done = true
//        }
        
        
    }
    
    @IBAction func addNewTodoItemBtnpressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add items", message: "add todo items", preferredStyle: .alert)
        
        alert.addTextField { (itemTextField) in
            itemTextField.placeholder = "create new item"
            textField = itemTextField
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            
            if self.itemArray.count > 0 {
                let endIndex = IndexPath(row: self.itemArray.count - 1, section: 0)
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        do {
            
           try context.save()
        } catch {
            print("error saving context\(error)")
        }
        tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("error fetching data\(error)")
        }
        tableView.reloadData()
}
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
