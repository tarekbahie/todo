//
//  CategoryVC.swift
//  todo
//
//  Created by tarek bahie on 1/29/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell
        else {
            return UITableViewCell()
        }
        cell.categoryTitle.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        cell.categoryTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

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
    
    
    
    
    
    // MARK: - Navigation

     @IBAction func addBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Type Category Name !"
            textField = categoryTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
            let newCategory = Category()
            newCategory.name = textField.text!
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
