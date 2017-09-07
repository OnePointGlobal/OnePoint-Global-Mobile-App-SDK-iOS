//
//  CountriesTableViewController.m
//  SDKDemoApp
//
//  Created by OnePoint Global on 30/11/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "CountriesTableViewController.h"
#import <OPGSDK/OPGSDK.h>
#import <OPGSDK/OPGCountry.h>

@interface CountriesTableViewController ()

@end

@implementation CountriesTableViewController
@synthesize countryArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Country";
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    self.countryArray = [sdk getCountries:&error];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.countryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Country" forIndexPath:indexPath];
    OPGCountry *countryObj = self.countryArray[indexPath.row];
    cell.textLabel.text=countryObj.name;
    
    return cell;
}

@end
