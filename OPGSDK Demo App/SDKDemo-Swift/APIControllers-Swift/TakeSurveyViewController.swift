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

import Foundation
import UIKit

 
class TakeSurveyViewController : OPGViewController, OPGSurveyDelegate
{
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    var surveyRef : String!                        // Array of OPGSurvey Class from Previous ViewController
    
    override func viewDidLoad() {
        self.surveyDelegate = self;
       self.spinner.startAnimating()        // Spinner to show loading of Survey
        super.viewDidLoad()
        //let queryDictionary = ["value1": "Key1", "value2": "Key2"]
        //self.loadSurvey("SURVEY_REFERENCE", with: queryDictionary)      //Loading the survey with Query parameters
        self.loadSurvey(surveyRef)   // //Loading the survey
    }
    
    /***************** OPGSurveyDelegate Methods *******************/
    
    func didSurveyStartLoad() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func didSurveyFinishLoad() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func didSurveyCompleted() {
        self.navigationController?.popViewController(animated: true)

    }
}
