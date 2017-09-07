//
//  AuthenticationWithSocialMediaViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 01/12/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class AuthenticationWithSocialMediaViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtGoogleToken: UITextField!
    @IBOutlet weak var txtFacebookToken: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtGoogleToken.delegate=self
        self.txtFacebookToken.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authenticateWithGoogle(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        var obj : OPGAuthenticate?
        do {
            obj = try sdk.authenticate(withGoogle: "")
        }
        catch{
            print("Authentication Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
        if obj!.isSuccess.int32Value==1
        {
            self.showAlert(alertMessage: "Authentication Successful")
        }
        else
        {
            self.showAlert(alertMessage: (obj?.statusMessage)!)
        }
    }

    @IBAction func authenticateWithFacebook(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        var obj : OPGAuthenticate?
        do {
            obj = try sdk.authenticate(withFacebook: "")
        }
        catch{
            print("Authentication Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
        if obj!.isSuccess.int32Value==1
        {
            self.showAlert(alertMessage: "Authentication Successful")
        }
        else
        {
            self.showAlert(alertMessage: (obj?.statusMessage)!)
        }
    }

    func showAlert(alertMessage : String)
    {
        let alertController = UIAlertController(title: "OPGSDK", message: alertMessage, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
