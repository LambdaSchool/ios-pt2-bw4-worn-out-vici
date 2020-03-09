//
//  AddShoeTableViewController.swift
//  Worn Out
//
//  Created by Vici Shaweddy on 3/1/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import UIKit

protocol AddShoeTableViewControllerDelegate: AnyObject {
    func shoeWasUpdated(_ shoe: Shoe)
}

class AddShoeTableViewController: UITableViewController {
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var styleTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var primarySwitch: UISwitch!
    @IBOutlet weak var maxMilesTextField: UITextField!
    
    let brands = ["Adidas",
                  "Altra",
                  "ASICS",
                  "Brooks",
                  "Ecco USA",
                  "Hoka One One",
                  "Inov-8",
                  "K-SWISS",
                  "Merrell",
                  "Mizuno",
                  "Montrail",
                  "New Balance",
                  "Newton Racing",
                  "Nike",
                  "OluKai",
                  "On",
                  "Pearl Izumi",
                  "Puma",
                  "Reebok",
                  "Ryka",
                  "Solomon",
                  "Saucony",
                  "Sketchers",
                  "Spira",
                  "Topo Athletic",
                  "UK Gear",
                  "Under Armour",
                  "Vibram FiverFingers",
                  "Zoom",
                  "Other"]
    
    var selectedBrand: String?
    var shoeController: ShoeController?
    var shoe: Shoe?
    weak var delegate: AddShoeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBrandPicker()
        self.createToolbar()
        self.tapToDismiss()
        self.updateViews()
        
        if shoeController?.fetchPrimaryShoe() == nil {
            self.primarySwitch.isOn = true
        } else {
            self.primarySwitch.isOn = false
        }
    }
    
    private func updateViews() {
        if self.shoe != nil {
            self.navigationController?.title = "Edit Shoe"
            self.brandTextField.text = self.shoe?.brand
            self.styleTextField.text = self.shoe?.style
            self.nicknameTextField.text = self.shoe?.nickname
            
            if self.shoe?.isPrimary == true {
               self.primarySwitch.isOn = true
            } else {
               self.primarySwitch.isOn = false
            }

            let maxMiles = self.shoe.flatMap { $0.displayMaxMiles }
            
            self.maxMilesTextField.text = maxMiles
        } else {
            self.navigationController?.title = "Add New Shoe"
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let brand = self.brandTextField.text, !brand.isEmpty,
            let nickname = self.nicknameTextField.text, !nickname.isEmpty else {
                let alert = UIAlertController(title: "Missing some fields", message: "Check your information and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        var primaryShoe: Bool = false
        if self.primarySwitch.isOn {
            primaryShoe = true
            print("It's primary shoe")
        } else if !self.primarySwitch.isOn {
            primaryShoe = false
            print("It's NOT primary shoe")
        }
        
        let style = self.styleTextField.text
        
        let maxMilesDouble = self.maxMilesTextField.text.flatMap { Double($0) } ?? 350
    
        if let shoe = self.shoe {
            self.shoeController?.updateShoe(shoe: shoe, brand: brand, style: style, nickname: nickname, maxMiles: maxMilesDouble, isPrimary: primaryShoe)
            
            self.delegate?.shoeWasUpdated(shoe)
        } else {
            self.shoeController?.addShoe(brand: brand, style: style, nickname: nickname, maxMiles: maxMilesDouble, isPrimary: self.primarySwitch.isOn)
        }
        
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
