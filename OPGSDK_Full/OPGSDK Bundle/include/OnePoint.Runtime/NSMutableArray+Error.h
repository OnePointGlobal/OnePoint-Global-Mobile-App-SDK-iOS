//
//  NSMutableArray+Error.h
//  TestRuntime
//
//  Created by Nitin on 14/03/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorList.h"

@interface NSMutableArray (Error)

@property (nonatomic, assign) int count_;
@property (nonatomic, retain) ErrorList *errorList_;


- (ErrorList *)getErrorList;
- (void)synErrWithInt:(int)line
              withInt:(int)col
              withInt:(int)n;
- (void)semErrWithInt:(int)line
              withInt:(int)col
         withNSString:(NSString *)s;
- (void)semErrWithInt:(int)line
              withInt:(int)col
         withNSString:(NSString *)s
         withNSString:(NSString *)fileName;
- (void)semErrWithNSString:(NSString *)s;
- (void)warningWithInt:(int)line
               withInt:(int)col
          withNSString:(NSString *)s;
- (void)warningWithInt:(int)line
               withInt:(int)col
          withNSString:(NSString *)s
          withNSString:(NSString *)fileName;
- (void)warningWithNSString:(NSString *)s;
- (id)init;
@end

