//
//  InputViewController.swift
//  Todo
//
//  Created by Sakai Aoi on 2021/02/15.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var deadlineDatePicker: UIDatePicker!
    
    var realm: Realm!
    var selectedIndexPath: IndexPath!
    var selectedTitle: String!
    var selectedDeadline: Date!
    var isEditable: Bool = false
    var todoItems: Results<TodoItem>!
    
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        if isEditable {
            titleTextField.text = selectedTitle
            deadlineDatePicker.setDate(selectedDeadline, animated: true)
        }
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView" {
            save()
            let vc = segue.destination as! ViewController
        }
    }
    
    func save() {
        let optionalTitle: String = titleTextField.text!
        
        
        print(formatter.string(from: deadlineDatePicker.date))
        if optionalTitle.isEmpty {
            print("タイトルが未入力")
        }else{
            print(optionalTitle)
            let todoItem = TodoItem(title: optionalTitle, deadline: deadlineDatePicker.date)
            let realm = try! Realm()
            do {
                try realm.write {
                    if isEditable {
                        todoItems = realm.objects(TodoItem.self)
                        let selectedTodoItem: TodoItem = todoItems[selectedIndexPath.row]
                        selectedTodoItem.title = todoItem.title
                        selectedTodoItem.deadline = todoItem.deadline
                        isEditable = false
                    }else{
                        let sortedTodoItems = realm.objects(TodoItem.self).sorted(byKeyPath: "order")
                        print("sorted")
                        print(sortedTodoItems)
                        print(sortedTodoItems.last)
                        todoItem.order = (sortedTodoItems.last?.order ?? -1) + 1
                        print(sortedTodoItems.last?.order ?? 0)
                        realm.add(todoItem)
                    }
                    
                    print(realm.objects(TodoItem.self))
                }
            } catch let error as NSError {
                
            }
        }
        
        
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
