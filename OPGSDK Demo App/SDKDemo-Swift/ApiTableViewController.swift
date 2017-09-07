//
//  ViewController.swift
//  SDKDemo-Swift
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class ApiTableViewController: UITableViewController {

    var apiArray: Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
    self.tableView.separatorColor = UIColor.orange
        // Do any additional setup after loading the view, typically from a nib.
        apiArray = ["Authenticate","Authenticate - Social Media","GetPanels","GetSurveys","Forgot password","Change Password","Download Media","Upload Media","GetPanellistProfile","UpdatePanellistProfile","Geofencing","GetCountries","Take Demo"]
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.apiArray.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = self.apiArray[indexPath.row]
        
        
     
     // Configure the cell...
     
     return cell
     }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let row = indexPath.row

        switch row {
        case 0  :
            self.performSegue(withIdentifier: "authenticate", sender: nil)
            break
        case 1  :
            self.performSegue(withIdentifier: "socialMediaAuthentication", sender: nil)
            break
        case 2  :
            self.performSegue(withIdentifier: "getPanels", sender: nil)
            break
        case 3  :
            self.performSegue(withIdentifier: "getSurveys", sender: nil)
            break
        case 4  :
            self.performSegue(withIdentifier: "forgotPassword", sender: nil)
            break
        case 5  :
            self.performSegue(withIdentifier: "changePassword", sender: nil)
            break
        case 6  :
            self.performSegue(withIdentifier: "downloadMedia", sender: nil)
            break
        case 7  :
            self.performSegue(withIdentifier: "uploadMedia", sender: nil)
            break
        case 8  :
            self.performSegue(withIdentifier: "getPanellistProfile", sender: nil)
            break
        case 9  :
            self.performSegue(withIdentifier: "updatePanellistProfile", sender: nil)
            break
        case 10  :
            self.performSegue(withIdentifier: "geofencing", sender: nil)
            break
        case 11 :
            self.performSegue(withIdentifier: "getCountries", sender: nil)
            break
        case 12 :
            self.performSegue(withIdentifier: "demoSurveySwift", sender: nil)
            break
        default : break
        }


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

