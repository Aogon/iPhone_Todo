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
    var isEditable: Bool = false
    var todoItems: Results<TodoItem>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .dateAndTime
        if isEditable {
            todoItems = realm.objects(TodoItem.self)
            titleTextField.text = todoItems[selectedIndexPath.row].title
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView" {
            save()
            let vc = segue.destination as! ViewController
        }
    }
    
    func save() {
        let optionalTitle: String = titleTextField.text!
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        print(formatter.string(from: deadlineDatePicker.date))
        if optionalTitle.isEmpty {
            print("タイトルが未入力")
        }else{
            print(optionalTitle)
            let todoItem = TodoItem(title: optionalTitle, deadline: formatter.string(from: deadlineDatePicker.date))
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.add(todoItem)
                    print(realm.objects(TodoItem.self))
                }
            } catch let error as NSError {
                
            }
        }
        
        
        
    }
    
    @IBAction func cancel() {
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
