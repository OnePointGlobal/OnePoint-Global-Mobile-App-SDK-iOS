//
//  Control.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 13/03/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IControl.h"
#import "QueryManager.h"
#import "Controls.h"
#import "GDataXMLNode.h"
@class HtmlControl;
@class SubTemplate;
@class Data;
@class Banner;
@class NavButton;
@class ProgressBar;
@class WebRequest;
@class Page;
@class Form;
@class Literal;
@class NavBar;

@interface Control : NSObject<IControl>
{
      NSString *__ClientId_;
      Controls *__Controls_;
      NSString *__CssClass_;
      QueryManager *__Arguments_;
      id<IControl> __Parent_;
      Page *__Page_;
      BOOL __Visible_;
      NSString *__BaseClientId_;
}

- (id)init;
- (id)initWithIControl:(id<IControl>)parent;
- (id)initWithIControl:(id<IControl>)parent
      withQueryManager:(QueryManager *)arguments;
- (NSString *)getClientId;
- (void)setClientId:(NSString *)value;
- (Controls *)getControls;
- (void)setControls:(Controls *)value;
- (NSString *)getCssClass;
- (void)setCssClass:(NSString *)value;
- (QueryManager *)getArguments;
- (void)setArguments:(QueryManager *)value;
- (id<IControl>)getParent;
- (void)setParent:(id<IControl>)value;
- (Page *)getPage;
- (void)setPage:(Page *)value;
- (BOOL)getVisible;
- (void)setVisible:(BOOL)value;
- (BOOL)getHasControls;
- (NSString *)getBaseClientId;
- (void)setBaseClientId:(NSString *)value;
+ (id<IControl>)createWithIControl:(id<IControl>)parent
                                  withTemplate:(NSString *)template_
                                  withIControl:(id<IControl>)insertControl;
+ (void)inspectChildren:(id<IControl>)parent
           withTemplate:(NSString *)template_;
+(void)inspectChildren:(id<IControl>) parent withBool:(BOOL)status xmlNode:(GDataXMLNode*) node  withIControl:(id<IControl>)insertControl;
- (id<IControl>)findControl:(id)controlType;
- (id<IControl>)findControlWithClientID:(NSString *)clientId;
- (id<IControl>)findControl:(NSString *)previousClientId
                           withClientId:(NSString *)clientId;
- (void)render:(id<IResponse>)response;
- (NSString *)extractControlIdentity:(NSString *)clientId;
//- (id)clone;
- (id)copyWithZone:(NSZone *)zone;
-(NSMutableArray*)findAll:(NSString*)clientId;
+(void)inspectNode:(id<IControl>)parent withBool:(BOOL)status xmlNode:(GDataXMLNode*)node insetControl:(id<IControl>)control;
+(NSString*)getNodeName:(GDataXMLNode*)node;
+(id<IControl>)generateControl:(id<IControl>)parent withBool:(BOOL)status XmlNode:(GDataXMLNode*)node  queryManager:(QueryManager*)arguments Control:(id<IControl>)insertControl;
+(NSString*)extractControlIdentity:(NSString*)clientID;

@end
