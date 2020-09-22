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
    @objc var timeOperationStep: Timer!
    var timer = Timer()
    
    var totatTime = 0
    @IBOutlet weak var topLabelTime: UILabel!
    
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
        print("Кол-во элементов \(itemExersiceArray.count)")
        //Приводим кол-во элементов в массиве = кол-ву элементов в чек листе для замера
        timeExersiceArray = [0]
        var chek = 0
        while chek < itemExersiceArray.count-1 {
            timeExersiceArray.append(contentsOf: [0])
            chek += 1
        }
        print ("Создан массив из элементов\(timeExersiceArray)")
        return itemExersiceArray.count
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
        startTimer()
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        endTimer()
    }
    

    @objc  func timeOperation() /*-> Int*/ {
        totatTime += 1
        print("Время шага \(totatTime) секунд")
        topLabelTime.text = timeFormatted(totatTime)
    }

    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeOperation), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        timer.invalidate()
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = (totalSeconds / 60/60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
