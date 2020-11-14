//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        self.saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let itemName = textField.text  {
                if itemName != "" {
                    
                    let newItem = Item(context: self.context)
                    newItem.title = itemName
                    newItem.category = self.selectedCategory
                    self.items.append(newItem)
                    
                    self.saveItems()
                
                    self.tableView.reloadData()
                    
                }
            }
        }
        alert.addAction(action)
        
        alert.addTextField(configurationHandler: {(alertTextField : UITextField!) -> Void in
            alertTextField.placeholder = "Item name"
            textField = alertTextField
        })
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(items)
//            try data.write(to: dataFilePath!)
//
//        } catch {
//            print("Error while saving data")
//        }
        do {
            try context.save()
        } catch {
            print("Error while saving data")
        }
        tableView.reloadData()
    }
    
    func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            self.items = try context.fetch(request)
        } catch  {
            print("Error while loading data")
        }
        tableView.reloadData()
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                items = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error while loading data")
//            }
//
//        }
    }
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchText = searchBar.text
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        if (searchText != "") {
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        }
//        loadItems(request: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var predicate : NSPredicate? = nil
        if  searchText != "" {
            predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
        loadItems(request: request, predicate: predicate)
    }
}


