//
//  GetSurveysViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class GetSurveysViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var panelIDField: UITextField!
    var surveyList : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.panelIDField.delegate=self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getSUrveySwift(_ sender: AnyObject)
    {
        
        let sdk = OPGSDK()        // Creating OPGSDK instance
        
        if self.panelIDField.text == ""
        {
            do {
                self.surveyList = try sdk.getUserSurveyList() as NSArray        // Getting list of Surveys assigned to user
            }
            catch{
                print("User Survey not working")         /* @"Error Occured. Contact Support!" */
                
            }
        }
        else
        {
            do {
                self.surveyList = try sdk.getUserSurveyList(withPanelID: self.panelIDField.text) as NSArray        // Getting list of Surveys assigned to user
            }
            catch{
                print("User Survey not working")         /* @"Error Occured. Contact Support!" */
                
            }
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "getUserSurvey")
        {
            let surveyListVC : SurveyTableViewController  = segue.destination as! SurveyTableViewController
            surveyListVC.surveyListArray = self.surveyList
        }
    }

}
