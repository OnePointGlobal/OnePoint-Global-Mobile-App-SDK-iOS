//
//  GetPanellistProfileViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class GetPanellistProfileViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var panelTitle: UITextField!
    @IBOutlet weak var panelFname: UITextField!
    @IBOutlet weak var panelLname: UITextField!
    @IBOutlet weak var panelEmail: UITextField!
    @IBOutlet weak var panelMobNo: UITextField!
    @IBOutlet weak var panelAddr1: UITextField!
    @IBOutlet weak var panelAddr2: UITextField!
    @IBOutlet weak var panelDOB: UITextField!
    @IBOutlet weak var panelGender: UITextField!
    @IBOutlet weak var panelPostalCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        panelTitle.delegate=self
        panelFname.delegate=self
        panelLname.delegate=self
        panelEmail.delegate=self
        panelMobNo.delegate=self
        panelAddr1.delegate=self
        panelAddr2.delegate=self
        panelDOB.delegate=self
        panelGender.delegate=self
        panelPostalCode.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func setProfileSwift(_ obj : OPGPanellistProfile) -> Void
    {
        self.panelTitle.text = obj.title
        self.panelFname.text = obj.firstName
        self.panelLname.text = obj.lastName
        self.panelEmail.text = obj.email
        self.panelMobNo.text = obj.mobileNumber
        self.panelAddr1.text = obj.address1
        self.panelAddr2.text = obj.address2
        
        let start = obj.dob.index(obj.dob.startIndex, offsetBy: 0)
        let end = obj.dob.index(obj.dob.startIndex, offsetBy: 9)
        
        // get a sub-string with a ClosedRange
        let range = start...end
        self.panelDOB.text = obj.dob[range]
        self.panelGender.text = obj.gender.stringValue
        self.panelPostalCode.text = obj.postalCode
    }
    
    @IBAction func getPanProfile(_ sender: AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        do {
            let profile : OPGPanellistProfile = try sdk.getPanellistProfile()
            self.setProfileSwift(profile)
        }
        catch{
            print("Get Panellist Profile Failed")         /* @"Error Occured. Contact Support!" */
            
        }
        
    }
    
}
