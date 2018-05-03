//
//  Reference.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 19/05/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"
#import "ReferenceType.h"
#import "GDataXMLNode.h"
#import "XmlInterQuestion.h"
@interface Reference : Control<IControl>
{
     NSString *__Alt;
     NSString *__Border;
    NSString *__Href;
   NSString *__Id;
    ReferenceType __RefType;
    NSString* __Rel;
    NSString *__RelType;
   NSString *__Src;
    NSString *__Position;
    NSString *__PreHtml;
   NSString *__PostHtml;
   NSString *__Height;
    NSString *__Width;
    NSString *__Text;
   NSString *__Style;
    NSString *__Class;
    NSString *__OnClick;
}
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments;
-(id)initWithIControl:(id<IControl>)parent withQueryManager:(QueryManager *)arguments withNode:(GDataXMLNode*)node;
-(NSString*)getAlt ;
-(void)setAlt:(NSString*) value;

-(NSString*)getBorder;
-(void)setBorder:(NSString*) value;
-(NSString*)getHref ;
-(void)setHref:(NSString*)value;
-(NSString*)getId;
-(void)setId:(NSString*)value;
-(ReferenceType) getRefType ;
-(void)setRefType:(ReferenceType) value ;
-(NSString*)getRel ;
-(void)setRel:(NSString*) value ;
-(NSString*)getRelType ;
-(void)setRelType:(NSString*) value ;
-(NSString*)getSrc;
-(void)setSrc:(NSString*) value ;
-(NSString*)getPosition ;
-(void)setPosition:(NSString*) value;
-(NSString*)getPreHtml;
-(void)setPreHtml:(NSString*) value;
-(NSString*)getPostHtml ;
-(void)setPostHtml:(NSString*) value;
@end
