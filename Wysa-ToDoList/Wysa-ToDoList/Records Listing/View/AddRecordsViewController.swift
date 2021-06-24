//
//  AddRecordsViewController.swift
//  Wysa-ToDoList
//
//  Created by Sarthak Taneja on 21/06/21.
//

import UIKit

protocol AddDateToCore {
    func addData(title: String, dateTime: Date)
}

class AddRecordsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Public Properties
    var selectedDate: Date?
    var delegate: AddDateToCore?
    var viewModel = AddRecordsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateAndTimeTextField.inputView = datePicker
        dateAndTimeTextField.isEnabled = false
    }
    
    func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: errorHeading, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OK, style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func submitTapped() {
        
        let validate = viewModel.validation(title: titleTextField.text ?? "", date: dateAndTimeTextField.text ?? "")
        if !validate.isValid {
            showAlert(errorMessage: validate.errMessage)
            return
        }
        
        delegate?.addData(title: titleTextField.text ?? "", dateTime: selectedDate ?? Date())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short

        let strDate = dateFormatter.string(from: datePicker.date)
        dateAndTimeTextField.text = strDate
        selectedDate = datePicker.date
    }
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
