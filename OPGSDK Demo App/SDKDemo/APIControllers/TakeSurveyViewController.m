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

#import "TakeSurveyViewController.h"

@interface TakeSurveyViewController ()

@end

@implementation TakeSurveyViewController
@synthesize surveyRef,queryDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.spinner startAnimating];       // Spinner to show loading of Survey
    //queryDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"Key1", @"value2", @"Key2", nil];
    //[self loadSurvey:self.surveyRef withDictionary:queryDictionary];         //Loading the survey with parameters
    [self loadSurvey:self.surveyRef];         //Loading the survey
    self.surveyDelegate = self;
    
}

#pragma mark - OPGSurveyDelegate Methods
-(void)didSurveyCompleted {
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

-(void)didSurveyStartLoad {
    [self.spinner startAnimating];
    self.spinner.hidden = FALSE;
}

-(void)didSurveyFinishLoad {
    [self.spinner stopAnimating];
    self.spinner.hidden = TRUE;
}

@end

