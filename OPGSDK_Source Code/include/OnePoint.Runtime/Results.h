//
//  Results.h
//  Onepoint.IOM
//
//  Created by Varahala Babu on 02/07/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Results : NSObject{
    NSMutableArray *__Categorical;
    NSMutableArray *__Code;
     NSString *__OtherResult;
     NSString *__Answer;
     NSString *__Name;
}
-(id)initWithNSString:(NSString*)name;
-(NSMutableArray*) getCategorical;
-(void)setCategorical:(NSMutableArray*) value;
-(NSMutableArray*) getCode;
-(void)setCode:(NSMutableArray*) value;
-(NSString*) getOtherResult;
-(void) setOtherResult:(NSString*) value;
-(NSString*) getAnswer;
-(void)setAnswer:(NSString*) value;
-(NSString*)getName;
-(void)setName:(NSString*)value;
-(void)addCategory:(NSString*)name;
-(void)addCode:(NSString*) name;
-(NSString*) getCategoricalString;
-(NSString*) getCodeString;
-(NSString*) serialize:(NSMutableArray*) codes;
@end
