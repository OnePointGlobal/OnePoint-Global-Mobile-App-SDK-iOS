//
//  QuestionError.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 04/04/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"

@interface QuestionError : Control
{
    int index;
}
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments withIndex:(int)index;
-(void)render:(id<IResponse>)response;
@end
