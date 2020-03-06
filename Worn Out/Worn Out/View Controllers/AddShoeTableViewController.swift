//
//  AddShoeTableViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/1/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

class AddShoeTableViewController: UITableViewController {
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var primarySwitch: UISwitch!
    @IBOutlet weak var maxMilesTextField: UITextField!
    
    let brands = ["Nike",
                  "Adidas",
                  "Reebok",
                  "ASICS",
                  "New Balance",
                  "On",
                  "Hoka One One",
                  "Brooks",
                  "Other"]
    
    var selectedBrand: String?
    var shoeController: ShoeController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBrandPicker()
        self.createToolbar()
        self.tapToDismiss()
        
        if shoeController?.fetchPrimaryShoe() == nil {
            self.primarySwitch.isOn = true
        } else {
            self.primarySwitch.isOn = false
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let brand = self.brandTextField.text, !brand.isEmpty,
            let style = self.styleTextField.text,
            let nickname = self.nicknameTextField.text, !nickname.isEmpty else {
                let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let maxMilesDouble = self.maxMilesTextField.text.flatMap { Double($0) } ?? 350
    
        self.shoeController?.addShoe(brand: brand, style: style, nickname: nickname, maxMiles: maxMilesDouble, isPrimary: self.primarySwitch.isOn)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func tapToDismiss() {
        let tap = UITapGestureRecognizer(target: self.tableView, action: #selector(tableView.endEditing))
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
    }
    
    private func createBrandPicker() {
        let brandPicker = UIPickerView()
        brandPicker.delegate = self
        
        self.brandTextField.inputView = brandPicker
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
        self.brandTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
}

extension AddShoeTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.brands[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedBrand = self.brands[row]
        self.brandTextField.text = self.selectedBrand
    }
}

extension AddShoeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.brandTextField.resignFirstResponder()
        return true
    }
}
