//
//  QuestionBanner.h
//  TestRuntime
//
//  Created by Varahala Babu on 15/09/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import "Control.h"

@interface QuestionBanner : Control
{
    int index;
    NSString *name;
}
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments withIndex:(int)_index;
@end
