//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/chinthan/Framework/Logger/ConvertCode/OnePoint/Runtime/Expressions/Parser/Ast/AstConstant.java
//
//  Created by chinthan on 1/15/14.
//


@class Handler;
@protocol IParser;


#import "AstNode.h"

@interface  AstConstant :  AstNode {
}

- (id)initWithIParser:(id<IParser>)parser withNSString:(NSString *)value;
- (id)initWithIParser:(id<IParser>)parser withInt:(float)value;
- (id)initWithIParser:(id<IParser>)parser withLong:(long)value;
- (id)initWithIParser:(id<IParser>)parser withBoolean:(BOOL)value;
- (id)initWithIParser:(id<IParser>)parser withFloat:(float)value;
- (id)initWithIParser:(id<IParser>)parser;
- (NSString *)description;
- (NSString *)toStringWithStringFormatEnum:(StringFormat)format;
- (void)executeWithHandler:(Handler *)handler withBool:(BOOL)getValue;
- (void)executeWithHandler:(Handler *)handler withBool:(BOOL)getValue withBool:(BOOL)setObject;
@end
