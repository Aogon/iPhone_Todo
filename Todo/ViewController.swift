//
//  ViewController.swift
//  Todo
//
//  Created by Sakai Aoi on 2021/02/15.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!
    

    let realm = try! Realm()
    var todoItems: Results<TodoItem>!
    
    var selectedIndexPath: IndexPath!
    var selectedTitle: String!
    var selectedDeadline: Date!
    
    let formatter = DateFormatter()
    
    let today = Date()
    let twoWeeksLater = Date(timeIntervalSinceNow: 60 * 60 * 24 * 14)
    let threeDaysLater = Date(timeIntervalSinceNow: 60 * 60 * 24 * 3)
    let tomorrow = Date(timeIntervalSinceNow: 60 * 60 * 24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view.
        todoItems = realm.objects(TodoItem.self).sorted(byKeyPath: "order")
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInputView" {
            let inputViewController = segue.destination as! InputViewController
            inputViewController.selectedIndexPath = self.selectedIndexPath
            inputViewController.selectedTitle = self.selectedTitle
            inputViewController.selectedDeadline = self.selectedDeadline
            inputViewController.isEditable = true
        }
    }
    
    
    
    @IBAction func myUnwindAction(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if unwindSegue.identifier == "toView" {
            todoItems = realm.objects(TodoItem.self).sorted(byKeyPath: "order")
            table.reloadData()
        }
        
        print("reload")
    }
    
    @IBAction func edit(){
        if(table.isEditing){
            table.setEditing(false, animated: true)
        } else {
            table.setEditing(true, animated: true)
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        for todoItem in todoItems{
            cell?.textLabel?.text = todoItems[indexPath.row].title
            cell?.detailTextLabel?.text = formatter.string(from: todoItems[indexPath.row].deadline)
            if todoItems[indexPath.row].deadline < today{
                cell?.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            
            }else if todoItems[indexPath.row].deadline < tomorrow {
                cell?.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            }else if todoItems[indexPath.row].deadline < threeDaysLater{
                cell?.contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
            }else if todoItems[indexPath.row].deadline < twoWeeksLater{
                cell?.contentView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            }else{
                cell?.contentView.backgroundColor = UIColor.white
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! realm.write{
            realm.delete(todoItems[indexPath.row])
            todoItems = realm.objects(TodoItem.self).sorted(byKeyPath: "order")
            for todoItem in todoItems {
                if todoItem.order > indexPath.row {
                    todoItem.order -= 1
                }
            }
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        selectedTitle = todoItems[selectedIndexPath.row].title
        selectedDeadline = todoItems[selectedIndexPath.row].deadline
        performSegue(withIdentifier: "toInputView", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var itemsArray = Array(todoItems)
        let movedItem = itemsArray[sourceIndexPath.row]
        itemsArray.remove(at: sourceIndexPath.row)
        itemsArray.insert(movedItem, at: destinationIndexPath.row)
        todoItems = realm.objects(TodoItem.self).sorted(byKeyPath: "order")
        try! realm.write{
            if sourceIndexPath.row > destinationIndexPath.row{
                for i in 0..<todoItems.count {
                    if i == sourceIndexPath.row {
                        todoItems[i].order = destinationIndexPath.row
                    }else if destinationIndexPath.row <= i && i < sourceIndexPath.row {
                        todoItems[i].order += 1
                    }
                }
            }else{
                for i in 0..<todoItems.count {
                    if i == sourceIndexPath.row {
                        todoItems[i].order = destinationIndexPath.row
                    }else if sourceIndexPath.row < i && i <= destinationIndexPath.row {
                        todoItems[i].order -= 1
                    }
                }
            }
            
        }
    }
    
    
}

