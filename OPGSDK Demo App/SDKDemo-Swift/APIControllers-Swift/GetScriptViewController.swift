//
//  GetScriptViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class GetScriptViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var surveyId: UITextField!
    //var obj : OPGScript?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        surveyId.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func getScript(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        do {
            //obj = try sdk.getScript("OPGSurvey")
        }
        catch{
            print("GetSCript Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
//        if ( obj?.isSuccess.int32Value==1)
//        {
//            let alertController = UIAlertController(title: "OPGSDK", message: "Script Download Successful!", preferredStyle: .alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            present(alertController, animated: true, completion: nil)
//        }
//        else
//        {
//            let alertController = UIAlertController(title: "OPGSDK", message: "Script Download Failed!", preferredStyle: .alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            present(alertController, animated: true, completion: nil)
//        }

    }

}
