//
//  CategoryVC.swift
//  todo
//
//  Created by tarek bahie on 1/29/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipTableViewController {
    
    

    let realm = try! Realm()
    
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        guard let cellColor = UIColor(hexString: categoryArray?[indexPath.row].color) else {fatalError()}
        cell.backgroundColor = cellColor
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cellColor, isFlat: true)

        return cell
    }
 
// MARK: - Data Manipulation
    
    func save (Category : Category) {
        do {
            try realm.write {
                realm.add(Category)
            }
        } catch {
            print("error saving categoru : \(error)")
        }
        tableView.reloadData()
       
    }

    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting item : \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    
    
    // MARK: - Navigation

     @IBAction func addBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Type Category Name !"
            categoryTextField.spellCheckingType = .yes
            categoryTextField.autocorrectionType = .yes
            categoryTextField.autocapitalizationType = .sentences
            textField = categoryTextField
            
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            let newCategory = Category()
            newCategory.name = textField.text!
            let newColor = UIColor.randomFlat()
            newCategory.color = (newColor?.hexValue())!
            self.save(Category: newCategory)

        }))
        present(alert, animated: true, completion: nil)
        
        
     }
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
