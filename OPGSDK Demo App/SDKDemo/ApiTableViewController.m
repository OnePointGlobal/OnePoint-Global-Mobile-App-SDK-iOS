//
//  ApiTableViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 03/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "ApiTableViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface ApiTableViewController ()

@end

@implementation ApiTableViewController
@synthesize apiArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    apiArray = [NSArray arrayWithObjects:@"Authenticate",@"Authenticate - Social Media",@"GetPanels",@"GetSurveys",@"Forgot password",@"Change Password",@"Download Media",@"Upload Media",@"GetPanellistProfile",@"UpdatePanellistProfile",@"Geofencing",@"GetCountries",@"Take Demo", nil];
    self.tableView.separatorColor = [UIColor orangeColor];
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
    return apiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text=apiArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"authenticate" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"socialMediaAuthentication" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"getPanels" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"getSurveys" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"forgotPassword" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"changePassword" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"downloadMedia" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"uploadMedia" sender:self];
            break;
        case 8:
            [self performSegueWithIdentifier:@"getPanellistProfile" sender:self];
            break;
        case 9:
            [self performSegueWithIdentifier:@"updatePanellistProfile" sender:self];
            break;
        case 10:
            [self performSegueWithIdentifier:@"geofencing" sender:self];
            break;
        case 11:
            [self performSegueWithIdentifier:@"getCountries" sender:self];
            break;
        case 12:
            [self performSegueWithIdentifier:@"demoSurvey" sender:self];
            break;
        default:
            break;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
