//
//  SwipTableViewController.swift
//  todo
//
//  Created by tarek bahie on 1/30/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.5058823529, blue: 1, alpha: 1)
        deleteAction.image = UIImage(named: "clear_btn")
        return [deleteAction]
    
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
}
