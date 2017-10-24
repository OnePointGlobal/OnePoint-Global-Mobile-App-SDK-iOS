//
//  QuestionLabel.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 08/04/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"

@interface QuestionLabel : Control
{
    int index;
}
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments withIndex:(int)_index;
-(void)render:(id<IResponse>)response;
@end
