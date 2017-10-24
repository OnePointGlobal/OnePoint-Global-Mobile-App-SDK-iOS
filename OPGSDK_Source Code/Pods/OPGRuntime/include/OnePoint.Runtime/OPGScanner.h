//
//  Scanner.h
//  TestRuntime
//
//  Created by Varahala Babu on 11/09/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Page;
@protocol IResponse;
@interface OPGScanner : NSObject
{
    NSArray *matchTags;
    NSArray *htmlTagStrings;
    NSMutableArray *referenceTags;
    NSString *__Source;
    Page *__Page;
    NSString *__Result;
    BOOL __SubTemplate;
    NSMutableArray *htmlTags;
}
@end



