//
//  ToDoListVC.swift
//  todo
//
//  Created by tarek bahie on 1/26/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {

    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item(nameOfItme: "findBill", completion: false)
        itemArray.append(newItem)
        let newItem2 = Item(nameOfItme: "askBill", completion: false)
        itemArray.append(newItem2)
        let newItem3 = Item(nameOfItme: "killBill", completion: false)
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        itemArray = items
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        
        
        cell.accessoryType = item.done == true ?  .checkmark :  .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        
        return cell
        
    }
 
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == true {
//            itemArray[indexPath.row].done = false
//        } else {
//            itemArray[indexPath.row].done = true
//        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addNewTodoItemBtnpressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add items", message: "add todo items", preferredStyle: .alert)
        
        alert.addTextField { (itemTextField) in
            itemTextField.placeholder = "create new item"
            textField = itemTextField
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
            
            let newItem = Item(nameOfItme: textField.text!, completion: false)
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            if self.itemArray.count > 0 {
                let endIndex = IndexPath(row: self.itemArray.count - 1, section: 0)
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
