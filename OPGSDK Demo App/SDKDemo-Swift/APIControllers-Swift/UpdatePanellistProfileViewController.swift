//
//  UpdatePanellistProfileViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class UpdatePanellistProfileViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    var datePicker : UIDatePicker!

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobNo: UITextField!
    @IBOutlet weak var txtAddr1: UITextField!
    @IBOutlet weak var txtAddr2: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtTitle.delegate=self
        txtFname.delegate=self
        txtLname.delegate=self
        txtEmail.delegate=self
        txtMobNo.delegate=self
        txtAddr1.delegate=self
        txtAddr2.delegate=self
        txtDOB.delegate=self
        txtGender.delegate=self
        txtPostalCode.delegate=self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.isEqual(txtPostalCode) || textField.isEqual(txtGender) || textField.isEqual(txtDOB) || textField.isEqual(txtAddr2) || textField.isEqual(txtAddr1)
        {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
        
        if textField.isEqual(txtDOB)
        {
            self.pickUpDate(textField: self.txtDOB)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.isEqual(txtPostalCode) || textField.isEqual(txtGender) || textField.isEqual(txtDOB) || textField.isEqual(txtAddr2) || textField.isEqual(txtAddr1)
        {
            NotificationCenter.default.removeObserver(self);
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.viewHeight.constant = -170                    //iPhone 5S
        self.view.updateConstraints()
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.viewHeight.constant = 20                       //iPhone 5S
        self.view.updateConstraints()
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileSwift() -> OPGPanellistProfile
    {
        let obj : OPGPanellistProfile = OPGPanellistProfile()
        obj.title=txtTitle.text
        obj.firstName=txtFname.text
        obj.lastName=txtLname.text
        obj.email=txtEmail.text
        obj.mobileNumber=txtMobNo.text
        obj.address1=txtAddr1.text
        obj.address2=txtAddr2.text
        obj.dob=txtDOB.text
        if(!(txtGender.text?.isEmpty)!)
        {
            obj.gender=NSNumber(value: Int(txtGender.text!)! as Int)
        }
        obj.postalCode=txtPostalCode.text
        obj.mediaID = "111"
        obj.countryName = "India"
        obj.std = "91"
        return obj

    }
    
    @IBAction func updateProfile(_ sender: AnyObject)
    {
         let sdk = OPGSDK()        // Creating OPGSDK instance
        let profile : OPGPanellistProfile? = self.getProfileSwift()
        if(!(profile?.firstName.isEmpty)!)
        {
            do {
                try sdk.update(profile)
                let alertController = UIAlertController(title: "OPGSDK", message: "Profile Updated Successfully", preferredStyle: .alert)

                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)

                present(alertController, animated: true, completion: nil)

            }
            catch{
                print("Profile Update Failed")         /* @"Error Occured. Contact Support!" */

                let alertController = UIAlertController(title: "OPGSDK", message: "Profile Update Failed", preferredStyle: .alert)

                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)

                present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func pickUpDate(textField : UITextField)
    {
        
        // DatePicker
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216)
        self.datePicker = UIDatePicker(frame:rect)
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.gray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UpdatePanellistProfileViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(UpdatePanellistProfileViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    
    func doneClick()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtDOB.text = dateFormatter.string(from: datePicker.date)
        txtDOB.resignFirstResponder()
    }
    
    func cancelClick()
    {
        txtDOB.resignFirstResponder()
    }

}
