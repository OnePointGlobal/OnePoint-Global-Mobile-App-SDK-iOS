//
//  SavePointTracker.h
//  TestRuntime
//
//  Created by Varahala Babu on 08/10/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISavePoints.h"
#import "SavePoints.h"
#import "ISavePoint.h"
#import "Interview.h"

@interface SavePointTracker : NSObject{
    id<ISavePoints> __SavePoints;
    int current;
    int previous;
    Interview *_interview;
}
-(id)initWithSavePoints:(Interview *)savePoints;
-(id<ISavePoint>)getCurrent;
-(id<ISavePoints>)getSavePoints;
-(void)setSavePoints:(id<ISavePoints>)value;

-(id<ISavePoints>)getGoto;
-(id<ISavePoint>)getNext;
-(id<ISavePoints>)getFirst;
-(id<ISavePoints>)getLast;
-(id<ISavePoint>)getPrevious;
-(void)add:(id<ISavePoint>)savePoint;
-(id<ISavePoint>)moveBack;
-(id<ISavePoint>)moveFirst;
-(id<ISavePoint>)moveLast;
-(id<ISavePoint>)moveNext;

@end
