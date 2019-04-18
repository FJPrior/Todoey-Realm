//
//  ViewController.swift
//  Todoey
//
//  Created by Administrador on 25/01/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoitems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //  $$ Los UserDefaults nos permiten guardar informacion que permaneceran incluso despues de el cierre de la aplicación
    //    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK -  Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoitems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoitems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // Ternary operator ==>
            // W ? T : F   value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        
        
        return cell
    }
    
    //MARK: - TableVIew Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoitems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
            
        }
        
        tableView.reloadData()
        // Making the checkmark appear and disappear acordingly
    //    todoitems?[indexPath.row].done = !todoitems?[indexPath.row].done
        
        // $$$ Hace que se actualize la vista
        
    
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item Buttonon our UIAlert
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        // $$Item NECESITA tener un valor, por eso hay que dara valor inicial de falso
                        newItem.done = false
                        currentCategory.items.append(newItem)
                        
                    }
                    
                } catch {
                    print("Error saving the item in realm \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            // Grey text that dissappears when the user starts typing
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion:  nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    func saveItems() {
        // $$ Funcion que guarda el itemArray : [Item]
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        todoitems = selectedCategory?.items.sorted(byKeyPath: "titile", ascending: true)

        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
//extension ToDoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        // MUY IMPORTANTE [cd] permite que la CONTAINS no se fije en diactitics (å, ö, é)
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//        if searchBar.text?.count == 0 {
//            loadItems()
//        }
//
//        searchBar.resignFirstResponder()
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count != 0
//        {
//
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            // MUY IMPORTANTE [cd] permite que la CONTAINS no se fije en diactitics (å, ö, é)
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request, predicate: predicate)
//        } else {
//
//
//
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//
//
//    }
//
//}
//
//
