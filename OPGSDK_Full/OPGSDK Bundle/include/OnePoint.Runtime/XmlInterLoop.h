//
//  XmlInterLoop.h
//  TestRuntime
//
//  Created by Varahala Babu on 16/09/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import "XmlInterControl.h"

@interface XmlInterLoop : XmlInterControl
{
    BOOL includeLabel;
    int categoryType;
    int column_;
    int row_;
    
}
- (id)initWithIXmlInterControl:(id<IXmlInterControl>)parent withQuestion:(id<IQuestion>)question;
@end
