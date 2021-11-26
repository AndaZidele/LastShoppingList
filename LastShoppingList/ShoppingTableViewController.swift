//
//  ShoppingTableViewController.swift
//  LastShoppingList
//
//  Created by anda.zidele on 25/11/2021.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {

    var shopping = [Shopping]()

    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()

    }
    func loadData(){
        let request: NSFetchRequest<Shopping> = Shopping.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            shopping = result!
            tableView.reloadData()
            
        }catch{
            fatalError("error is in loading core item")
        }
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }catch{
            fatalError("error is in saving core item")
        }
        loadData()
    }
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        let delete: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try managedObjectContext?.execute(delete)
            saveData()
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    
    
    @IBAction func addNewItem(_ sender: Any) {
        
        print("Add activity!")
        
        let alertController = UIAlertController(title: "Shopping Item", message: "What do You want to add?", preferredStyle: .alert)
        alertController.addTextField { textField in
            print("textField: ", textField)
        }
        let addActionButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Shopping", in: self.managedObjectContext!)
            let shop = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            shop.setValue(textField?.text, forKey: "item")
            //self.shopping.append(textField!.text!)
            self.saveData()
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAllItems(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete All Shopping Items?", message: "Do You want to delete them all?", preferredStyle: .actionSheet)
        let addActionButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteAllData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shopping.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cellb...

        //cell.textLabel?.text = shopping[indexPath.row]
        
        let shop = shopping[indexPath.row]
        cell.textLabel?.text = shop.value(forKey: "item") as? String//"Item: \(shop.value(forKey: "item") ?? "")"
       // cell.detailTextLabel?.text = "Count: "
       // cell.accessoryType = shop.completed ? .checkmark : .none
        //shop.value(forKey: "item")
        
        
        return cell
    }
    
    
    
    // MARK: - Table view data source
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            managedObjectContext?.delete(shopping[indexPath.row])
        }
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shopping[indexPath.row].completed = !shopping[indexPath.row].completed
        saveData()
    }
    

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
