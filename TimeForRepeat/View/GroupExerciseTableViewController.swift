//
//  TableViewController.swift
//  TimeForRepeat
//
//  Created by shiryaev-da on 13.09.2020.
//  Copyright © 2020 shiryaev-da. All rights reserved.
//

import UIKit
import CoreData

class GroupExerciseTableViewController: UITableViewController {

    var itemGroupExercise = [GroupExercise]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

//Add new exercise
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
                     
                     let alert = UIAlertController (title: "Добавить новый замер", message: "", preferredStyle: .alert)
                     let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
                        // print(textField.text)
                        
                         
                         let newItem = GroupExercise(context: self.context)
                         newItem.name = textField.text!
                         self.itemGroupExercise.append(newItem)
                         //save data
                         self.saveItems()
                        // self.saveItems()
              
              }
              alert.addTextField { (alertTextField) in
                  alertTextField.placeholder = "Добавить новое измерение"
                  textField = alertTextField
              }
              
              alert.addAction(action)
              
              present(alert, animated: true, completion: nil)
    }
//MARK: - Data monpulation
    
// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemGroupExercise.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryExercise, for: indexPath)
        let item = itemGroupExercise[indexPath.row]
        print(item)
        cell.textLabel?.text = item.name!
        return cell
    }

 //MARK: - segue action
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("Cell pressed")
               performSegue(withIdentifier: K.segueStep, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCV = segue.destination as! StepProcessTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationCV.selectidGroup = itemGroupExercise[indexPath.row]
        }
    }
    
//MARK: - Data operation
    
    
    
    func saveItems() {
           
           do {
               try context.save()
                print("Информация сохранена")
           } catch {
             print("Ошибка сохранения нового замера\(error)")
           }
           self.tableView.reloadData()
       }
       
       func loadItems(with request: NSFetchRequest<GroupExercise> = GroupExercise.fetchRequest()) {
        //   let request : NSFetchRequest<Item> = Item.fetchRequest()
           do {
               itemGroupExercise = try context.fetch(request)
           } catch {
               print("Error load from CoreData Item\(error)")
           }
           tableView.reloadData()
       }
    

}
