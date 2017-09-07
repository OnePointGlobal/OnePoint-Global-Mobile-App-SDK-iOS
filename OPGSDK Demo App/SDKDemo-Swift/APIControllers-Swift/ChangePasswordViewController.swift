//
//  ChangePasswordViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var txtCurrPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    var obj : OPGChangePassword!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNewPass.delegate=self
        txtCurrPass.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changePassSwift(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        do {
            obj = try sdk.changePassword(txtCurrPass.text, newPassword: txtNewPass.text)
        }
        catch{
            print("Change Password Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        if (obj.isSuccess.boolValue == true)
        {
            let alertController = UIAlertController(title: "OPGSDK", message: "Password Changed Successfully", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "OPGSDK", message: "Password Change Failed", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

}
