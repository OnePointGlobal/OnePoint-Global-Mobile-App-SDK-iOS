//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/chinthan/Framework/Logger/ConvertCode/OnePoint/Runtime/VirtualMachine/Core/OnePointObject.java
//
//  Created by chinthan on 12/2/13.
//

#ifndef _OnePointObject_H_
#define _OnePointObject_H_

@class OnePointClass;
@class SuperClass;



@interface OnePointObject : NSObject {
 @public
  BOOL __IsSuperClass_;
  OnePointClass *__Class_;
  SuperClass *__SuperClass_;
  NSMutableArray *__Fields_;
  NSMutableArray *__StaticField_;
}

- (id)initWithOnePointClass:(OnePointClass *)currentClass;
- (id)initWithSuperClass:(SuperClass *)superClass;
- (id)get___idxWithNSString:(NSString *)index;
- (void)set___idxWithNSString:(NSString *)index
                       withId:(id)value;
- (BOOL)getIsSuperClass;
- (void)setIsSuperClassWithBoolean:(BOOL)value;
- (OnePointClass *)getThisClass;
- (void)setClassWithOnePointClass:(OnePointClass *)value;
- (SuperClass *)getSuperClass;
- (void)setSuperClassWithSuperClass:(SuperClass *)value;
- (NSMutableArray *)getFields;
- (void)setFieldsWithNSObjectArray:(NSMutableArray *)value;
- (NSMutableArray *)getStaticField;
- (void)setStaticFieldWithNSObjectArray:(NSMutableArray *)value;
@end



#endif // _OnePointObject_H_