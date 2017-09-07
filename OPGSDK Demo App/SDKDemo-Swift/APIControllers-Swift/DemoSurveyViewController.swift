//
//  DemoSurveyViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 06/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class DemoSurveyViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtSharedKey : UITextField!
    var surveyList : NSArray = []
    var obj:OPGAuthenticate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSharedKey.delegate=self
        self.txtUsername.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
        //self.activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnGOTapped(_ sender:AnyObject)
    {
        let sdk = OPGSDK()        // Creating OPGSDK instance
        if ((self.txtUsername.text?.characters.count)!>0 && (self.txtSharedKey.text?.characters.count)!>0)
        {
            do {
                obj = try sdk.authenticate(self.txtUsername.text, password: self.txtSharedKey.text) as OPGAuthenticate
            }
            catch{
                print("Authentication not working")         /* @"Error Occured. Contact Support!" */
                
            }
            
            do {
                self.surveyList = try sdk.getUserSurveyList() as NSArray        // Getting list of Surveys assigned to user
            }
            catch{
                print("User Survey not working")         /* @"Error Occured. Contact Support!" */
                
            }
            self.performSegue(withIdentifier: "embedSurveyList", sender: sender)
        }
        else
        {
            print("Username and Password can not be empty")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "embedSurveyList")
        {
            let surveyListVC : SurveyListViewController  = segue.destination as! SurveyListViewController
            surveyListVC.surveyListArray = self.surveyList
        }
        
    }


}
