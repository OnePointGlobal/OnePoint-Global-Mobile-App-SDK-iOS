//
//  StringResponse.h
//  TestRuntime
//
//  Created by Varahala Babu on 01/09/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IResponse.h"
@interface StringResponse : NSObject<IResponse>
{
    NSMutableString *mString;
}
@property(nonatomic,strong) NSMutableString *mString;
@end
