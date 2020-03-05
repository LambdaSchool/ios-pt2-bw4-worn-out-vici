//
//  RunDetailTableViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/3/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit
import CoreData

final class RunDetailTableViewController: UITableViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var shoeTextField: UITextField!
    
    private let context = CoreDataStack.shared.mainContext
    var shoes: [Shoe] = []
    var selectedShoe: Shoe?
    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectShoePicker()
        self.createToolbar()
        self.tapToDismiss()
        self.updateViews()
    }
    
    private func updateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let date = self.run?.startDate.map { dateFormatter.string(from: $0) }
        self.timeLabel.text = date
        
        let miles = self.run.map { String($0.miles) }
        self.milesLabel.text = miles
        
        self.shoes = retrieveShoes()
        self.shoeTextField.text = self.run?.shoe?.nickname
    }
    
    private func showSaveButton() {
        let item = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    private func retrieveShoes() -> [Shoe] {
        let fetchRequest: NSFetchRequest<Shoe> = Shoe.fetchRequest()
        
        do {
            let shoes = try self.context.fetch(fetchRequest)
            
            return shoes
        } catch let error as NSError {
            print("Could not fetch: \(error)")
            return []
        }
    }
    
    @objc func savePressed(_ sender: Any) {
        self.run?.shoe = self.selectedShoe
        do {
            try self.context.save()
        } catch {
            print("Error saving managed object content: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func tapToDismiss() {
        let tap = UITapGestureRecognizer(target: self.tableView, action: #selector(tableView.endEditing))
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
    }
    
    private func selectShoePicker() {
        let shoePicker = UIPickerView()
        shoePicker.delegate = self
        
        self.shoeTextField.inputView = shoePicker
    }
    
    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Creating flexible space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Creating Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        // Adding space and button to toolbar
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adding toolbar to input accessory view
        self.shoeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension RunDetailTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.shoes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.shoes[row].nickname
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newShoe = self.shoes[row]
        
        if self.selectedShoe != newShoe {
            self.showSaveButton()
        }
        
        self.selectedShoe = newShoe
        self.shoeTextField.text = self.selectedShoe?.nickname
    }
}

extension RunDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.shoeTextField.resignFirstResponder()
        return true
    }
}
