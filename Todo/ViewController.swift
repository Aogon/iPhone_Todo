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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view.
        todoItems = realm.objects(TodoItem.self)
        
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInputView" {
            let inputViewController = segue.destination as! InputViewController
            inputViewController.selectedIndexPath = self.selectedIndexPath
            inputViewController.isEditable = true
        }
    }
    
    @IBAction func myUnwindAction(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if unwindSegue.identifier == "toView" {
            todoItems = realm.objects(TodoItem.self)
            table.reloadData()
        }
        
        print("reload")
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        for todoItem in todoItems{
            cell?.textLabel?.text = todoItems[indexPath.row].title
            cell?.detailTextLabel?.text = todoItems[indexPath.row].deadline
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! realm.write{
            realm.delete(todoItems[indexPath.row])
            todoItems = realm.objects(TodoItem.self)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toNextViewContoller", sender: nil)
        selectedIndexPath = indexPath
    }
    
}

