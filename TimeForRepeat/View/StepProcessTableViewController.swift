//
//  StepProcessTableViewController.swift
//  TimeForRepeat
//
//  Created by shiryaev-da on 14.09.2020.
//  Copyright © 2020 shiryaev-da. All rights reserved.
//

import UIKit
import CoreData

class StepProcessTableViewController: UITableViewController {
    var itemExersiceArray = [Exercise]()
    var timeExersiceArray: [Int] = [0]
    
    @IBOutlet weak var TopLabelTotalTime: UILabel!
    
    var time_step: Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectidGroup : GroupExercise? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //regist reuseble cell
        tableView.register(UINib(nibName: "StepCell", bundle: nil), forCellReuseIdentifier: K.nameReusableCellStep )
        
    }

    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  itemExersiceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.nameReusableCellStep, for: indexPath) as! StepCell
        let item = itemExersiceArray[indexPath.row]
        print(item)
        cell.label?.text = item.name!
        cell.labelTimeCell.text = String(format:  "%.1f", time_step)
        //cell.textLabel?.text = item.name!
        return cell
    }

 //MARK: - Table View Delegete
    
    
    
    
    
//MARK: - Data monipulation
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               
               let alert = UIAlertController (title: "Добавить действие", message: "", preferredStyle: .alert)
               let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
                  // print(textField.text)
                  
                   
                   let newItem = Exercise(context: self.context)
                   newItem.name = textField.text!
                   newItem.perentGroupExercise = self.selectidGroup
                    print("Добалвен элемент\(self.selectidGroup!)")
                   self.itemExersiceArray.append(newItem)
                   //save data
                   self.saveItems()
                  // self.saveItems()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Добавить новое действие"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
              self.tableView.reloadData()
          }
          
          func loadItems(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest()) {
            let predicate =  NSPredicate(format: "perentGroupExercise.name MATCHES %@", selectidGroup!.name!)
            
            request.predicate = predicate
            
            do {
                  itemExersiceArray = try context.fetch(request)
               // print("Загружено \(itemExersiceArray[0])")
              } catch {
                  print("Error load from CoreData Item\(error)")
              }
              tableView.reloadData()
          }
//MARK: - Opretion on timer
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timeOperation(typeAction: 0)
        let item = itemExersiceArray[indexPath.row]
        print(item)
     
       // cell.label?.text = item.name!
      //  cell.labelTimeCell.text = String(format:  "%.1f", time_step)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        timeOperation(typeAction: 1)
    }
    

    func timeOperation(typeAction: Int = 1) /*-> Int*/ {
        //If start and not chenge cell (0)
        
        
        if typeAction == 0 {
           print("Time start")
        } else
        {
           print("Time stop")
        }
        //return 1
    }

}
