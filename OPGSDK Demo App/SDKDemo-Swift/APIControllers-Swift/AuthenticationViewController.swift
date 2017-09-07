//
//  AuthenticationViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var obj : OPGAuthenticate?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        username.delegate=self
        password.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticate(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        do {
            obj = try sdk.authenticate(self.username.text, password: self.password.text)
        }
        catch{
            print("Authentication Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
        if obj!.isSuccess.int32Value==1
        {
            let alertController = UIAlertController(title: "OPGSDKv1.0", message: "Authentication Successful", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "OPGSDKv1.0", message: "Authentication Failed", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
