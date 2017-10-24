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

#import "OPGSurvey.h"

@implementation OPGSurvey

@synthesize isGeoFencing,surveyName,surveyDescription,isOffline,lastUpdatedDate,surveyReference,surveyID,estimatedTime, deadline, status,createdDate,isOfflineDownloaded, startDate, endDate;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (surveyName !=nil) {
        [dict setObject:surveyName forKey:@"surveyName"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyName"];
    }
    
    if (surveyDescription !=nil) {
        [dict setObject:surveyDescription forKey:@"surveyDescription"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyDescription"];
        
    }
    
    if (isGeoFencing !=nil) {
        [dict setObject:isGeoFencing forKey:@"isGeoFencing"];
    }
    else{
        [dict setObject:@"" forKey:@"isGeoFencing"];
        
    }
    
    if (isOffline !=nil) {
        [dict setObject:isOffline forKey:@"isOffline"];
    }
    else{
        [dict setObject:@"" forKey:@"isOffline"];
        
    }

    if (startDate !=nil) {
        [dict setObject:startDate forKey:@"startDate"];
    }
    else{
        [dict setObject:@"" forKey:@"startDate"];
    }

    if (endDate !=nil) {
        [dict setObject:endDate forKey:@"endDate"];
    }
    else{
        [dict setObject:@"" forKey:@"endDate"];
    }

    if (createdDate !=nil) {
        [dict setObject:createdDate forKey:@"createdDate"];
    }
    else{
        [dict setObject:@"" forKey:@"createdDate"];
    }

    
    if (lastUpdatedDate !=nil) {
        [dict setObject:lastUpdatedDate forKey:@"lastUpdatedDate"];
    }
    else{
        [dict setObject:@"" forKey:@"lastUpdatedDate"];
        
    }
    
    if (surveyReference !=nil) {
        [dict setObject:surveyReference forKey:@"surveyReference"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyReference"];
        
    }
    
    if (surveyID !=nil) {
        [dict setObject:surveyID forKey:@"surveyID"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyID"];
        
    }
    
    if (estimatedTime !=nil) {
        [dict setObject:estimatedTime forKey:@"estimatedTime"];
    }
    else{
        [dict setObject:@"" forKey:@"estimatedTime"];
        
    }
    
    if (deadline !=nil) {
        [dict setObject:deadline forKey:@"deadline"];
    }
    else{
        [dict setObject:@"" forKey:@"deadline"];
        
    }
    
    if (status !=nil) {
        [dict setObject:status forKey:@"status"];
    }
    else{
        [dict setObject:@"" forKey:@"status"];
        
    }
    
    if (isOfflineDownloaded !=nil) {
        [dict setObject:isOfflineDownloaded forKey:@"isOfflineDownloaded"];
    }
    else{
        [dict setObject:@"" forKey:@"isOfflineDownloaded"];
        
    }
    
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.isGeoFencing forKey:@"isGeoFencing"];
    [encoder encodeObject:self.surveyName forKey:@"surveyName"];
    [encoder encodeObject:self.surveyDescription forKey:@"surveyDescription"];
    [encoder encodeObject:self.isOffline forKey:@"isOffline"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.surveyReference forKey:@"surveyReference"];
    [encoder encodeObject:self.surveyID forKey:@"surveyID"];
    [encoder encodeObject:self.estimatedTime forKey:@"estimatedTime"];
    [encoder encodeObject:self.deadline forKey:@"deadline"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.isOfflineDownloaded forKey:@"isOfflineDownloaded"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.isGeoFencing = [decoder decodeObjectForKey:@"isGeoFencing"];
        self.surveyName = [decoder decodeObjectForKey:@"surveyName"];
        self.surveyDescription = [decoder decodeObjectForKey:@"surveyDescription"];
        self.isOffline = [decoder decodeObjectForKey:@"isOffline"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.surveyReference = [decoder decodeObjectForKey:@"surveyReference"];
        self.surveyID = [decoder decodeObjectForKey:@"surveyID"];
        self.estimatedTime = [decoder decodeObjectForKey:@"estimatedTime"];
        self.deadline = [decoder decodeObjectForKey:@"deadline"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.isOfflineDownloaded = [decoder decodeObjectForKey:@"isOfflineDownloaded"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];

    }
    return self;
}

@end
