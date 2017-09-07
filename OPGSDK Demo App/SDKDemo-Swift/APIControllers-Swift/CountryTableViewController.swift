//
//  CountryTableViewController.swift
//  SDKDemoApp
//
//  Created by OnePoint Global on 30/11/16.
//  Copyright © 2016 opg. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController
{
    var countryList : [OPGCountry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Country"
        self.tableView.separatorColor = UIColor.orange
        let sdk = OPGSDK()        // Creating OPGSDK instance
        do {
            self.countryList = try sdk.getCountries() as! [OPGCountry]
        }
        catch{
            print("GetCountries not working")         /* @"Error Occured. Contact Support!" */
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.countryList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)

        let country : OPGCountry = self.countryList[indexPath.row]
        cell.textLabel?.text=country.name
        return cell
    }

}
