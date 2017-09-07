//
//  DownloadMediaViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class DownloadMediaViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var txtMediaID: UITextField!
    @IBOutlet weak var txtMediaType: UITextField!
    var obj : OPGDownloadMedia?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMediaType.delegate=self
        txtMediaID.delegate=self
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
    
    @IBAction func downloadMedia(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        do {
            obj = try sdk.downloadMediaFile(txtMediaID.text, mediaType: txtMediaType.text)
        }
        catch{
            print("Download Media Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
        if (obj?.isSuccess.int32Value==1)
        {
            let alertController = UIAlertController(title: "OPGSDKv1.0", message: "Media Download Successful!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "OPGSDKv1.0", message: "Media Download Failed!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }


}
