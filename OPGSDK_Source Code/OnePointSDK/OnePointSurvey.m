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

#import "OnePointSurvey.h"

@implementation OnePointSurvey

@synthesize IsGeoFencing,Name,Description,ScriptID,IsOffline,LastUpdatedDate,SurveyReference;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:Name forKey:@"Name"];
    [dict setObject:Description forKey:@"Description"];
    [dict setObject:IsGeoFencing forKey:@"IsGeoFencing"];
    [dict setObject:ScriptID forKey:@"ScriptID"];
    [dict setObject:IsOffline forKey:@"IsOffline"];
    [dict setObject:LastUpdatedDate forKey:@"LastUpdatedDate"];
    [dict setObject:SurveyReference forKey:@"SurveyReference"];
    
    return [dict description];
}

@end
