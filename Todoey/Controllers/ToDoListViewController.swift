//
//  ViewController.swift
//  Todoey
//
//  Created by Administrador on 25/01/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item] ()
    
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
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // W ? T : F   value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableVIew Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        //        print("Another option")
        //        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as! String)
        
        
        // Making the checkmark appear and disappear acordingly
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // $$$ Hace que se actualize la vista
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item Buttonon our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            // $$Item NECESITA tener un valor, por eso hay que dara valor inicial de falso
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
         
            // $$ self.defaults.set(self.itemArray, forKey: "ToDoListArray") esto era para cuando se usaba UserDefaults

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
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = predicate != nil ? NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!] ) : categoryPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error  fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // MUY IMPORTANTE [cd] permite que la CONTAINS no se fije en diactitics (å, ö, é)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        if searchBar.text?.count == 0 {
            loadItems()
        }
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count != 0
        {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            // MUY IMPORTANTE [cd] permite que la CONTAINS no se fije en diactitics (å, ö, é)
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        } else {
            
            
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
        
        
    }
    
}


