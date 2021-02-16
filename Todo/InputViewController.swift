//
//  InputViewController.swift
//  Todo
//
//  Created by Sakai Aoi on 2021/02/15.
//

import UIKit

class InputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var deadlineDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        // Do any additional setup after loading the view.
        deadlineDatePicker.preferredDatePickerStyle = .inline
        deadlineDatePicker.datePickerMode = .date
        
        
    }
    
    @IBAction func save() {
        let optionalTitle: String = titleTextField.text!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        print(formatter.string(from: deadlineDatePicker.date))
        if optionalTitle.isEmpty {
            print("タイトルが未入力")
        }else{
            print(optionalTitle)
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
