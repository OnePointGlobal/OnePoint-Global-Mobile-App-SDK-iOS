//
//  GetPanelsViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class GetPanelsViewController: UITableViewController
{
    var panelsObjList : NSArray = []
    var panelsIDList : NSArray = []
    var panellistPanelObj : OPGPanellistPanel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.orange
        let sdk = OPGSDK()        // Creating OPGSDK instance
        do {
            self.panellistPanelObj = try sdk.getPanellistPanel()
            self.panelsObjList = panellistPanelObj.panelsArray as NSArray       // Getting list of Panels assigned to user
            self.panelsIDList = self.getPanelsIDList(self.panelsObjList)
        }
        catch{
            print("Get Panels not working")         /* @"Error Occured. Contact Support!" */
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getPanelsIDList(_ obj : NSArray) -> NSArray
    {
        let panelsIDArray : NSMutableArray = []
        for panel in obj as! [OPGPanel]
        {
            panelsIDArray.add(panel.panelName)
        }
        return panelsIDArray
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.panelsIDList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier: "CELL")
        }
        // setup cell without force unwrapping it
        cell?.textLabel!.text = self.panelsIDList[(indexPath as NSIndexPath).row] as? String
        return cell!
        
        
    }

}
