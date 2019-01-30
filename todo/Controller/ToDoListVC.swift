//
//  ToDoListVC.swift
//  todo
//
//  Created by tarek bahie on 1/26/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListVC: SwipTableViewController, UISearchBarDelegate {
  
    @IBOutlet weak var searchBar: UISearchBar!
    

    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedCategory?.name
        guard let colourHex = selectedCategory?.color else {fatalError()}
        updateNavBar(withHexCode: colourHex)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavBar(withHexCode: "7A81FF")
        
        
    }
    // MARK: - NavBar methods
    func updateNavBar(withHexCode colourHexcode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError()}
        guard let navBarColor = UIColor(hexString: colourHexcode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor(hexString: item.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems!.count)))
            
            
            
            print("Version 1 :\(CGFloat((indexPath.row / (todoItems?.count ?? 1))))")
            print("Version 2 :\(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
            
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
            }
            } catch {
                print("error saving done status \(error)")
            }
        }

        tableView.reloadData()
    }

    // MARK: - IBAction
    
    @IBAction func addNewTodoItemBtnpressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add items", message: "add todo items", preferredStyle: .alert)
        
        alert.addTextField { (itemTextField) in
            itemTextField.placeholder = "create new item"
            itemTextField.spellCheckingType = .yes
            itemTextField.autocorrectionType = .yes
            itemTextField.autocapitalizationType = .sentences
            textField = itemTextField
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        newItem.color = currentCategory.color
                        print(newItem.color)
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
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item : \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
// MARK: - SearchBar Delegate
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
