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

import UIKit
import Foundation



class SurveyListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var surveyListTableView : UITableView!
    var surveyListArray : NSArray!                        // Array of OPGSurvey Class from Previous ViewController
    var surveyReference : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.surveyListTableView.separatorColor = UIColor.orange
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveyListArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell : SurveyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! SurveyTableViewCell
        /* OPGSurvey class has properties such as Name, description, IsOffline, LastUpdatedDate, IsGeoFencing, ScriptID and SurveyReference
         Getting instance of OPGSurvey from the array */
        let survey : OPGSurvey = surveyListArray.object(at: (indexPath as NSIndexPath).row) as! OPGSurvey
        tableViewCell.fillCell(survey)                // filling the custom tableview cell with OnePoint Survey class Instance
        return tableViewCell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let survey : OPGSurvey = self.surveyListArray.object(at: (indexPath as NSIndexPath).row) as! OPGSurvey
        self.surveyReference = survey.surveyReference as NSString!    // Survey reference property of OPGSurvey class is passed to next controller which is required to run the survey.
        self.performSegue(withIdentifier: "embedTakeSurvey", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "embedTakeSurvey")
        {
            // Get TakeSurveyViewController view
            let viewController : TakeSurveyViewController = segue.destination as! TakeSurveyViewController
            viewController.surveyRef=self.surveyReference as String
        }
        
    }
    
}
