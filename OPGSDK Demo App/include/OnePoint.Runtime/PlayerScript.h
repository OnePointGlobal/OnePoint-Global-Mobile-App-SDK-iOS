//
//  Script.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 16/05/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"
#import "XmlInterQuestion.h"

@interface PlayerScript : Control
{
    NSString* __Text;
    BOOL __Head;
}
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments;
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments withXmlNode:(GDataXMLNode*)node;
-(void)setText:(NSString*)value;
-(NSString*)getText;
-(BOOL) getHead;
-(void)setHead:(BOOL)value;

@end
