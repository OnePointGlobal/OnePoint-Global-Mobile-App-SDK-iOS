//
// Copyright (c) 2016 OnePoint Global Ltd. All rights reserved.
//
// This code is licensed under the OnePoint Global License.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "SurveyListViewController.h"
#import "SurveyTableViewCell.h"
#import "TakeSurveyViewController.h"
#import <OPGSDK/OPGSDK.h>
#import <OPGSDK/OPGSurvey.h>


@interface SurveyListViewController ()

@property(strong, nonatomic) NSString* surveyRef;

@end

@implementation SurveyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.surveyTableView.separatorColor = [UIColor orangeColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveyTableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    
    /* OPGSurvey class has properties such as Name, description, IsOffline, LastUpdatedDate, IsGeoFencing, ScriptID and SurveyReference
     Getting instance of OPGSurvey from the array */
    OPGSurvey *survey = [self.surveyListArray objectAtIndex:indexPath.row];
    
    [tableViewCell fillCell:survey];         // filling the custom tableview cell with OnePoint Survey class Instance
    
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OPGSurvey *survey = [self.surveyListArray objectAtIndex:indexPath.row];
    self.surveyRef = survey.surveyReference;  // Survey reference property of OPGSurvey class is passed to next controller which is required to run the survey.
    [self performSegueWithIdentifier:@"embedTakeSurvey" sender:self];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3.0f;
}

#pragma mark - Segues Operations
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"embedTakeSurvey"]) {
        // Get TakeSurveyViewController view
        TakeSurveyViewController *viewController = [segue destinationViewController];
        viewController.surveyRef = self.surveyRef;
    }
    
}


@end
