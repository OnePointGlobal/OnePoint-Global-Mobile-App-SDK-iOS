//
//  ISkeletonCollection.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 1/12/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISkeletonCollection <NSObject>

-(int)getCount;
-(id)getcurrent;
-(id)get___idx:(int)index;
-(void)set___idx:(int)index :(id)value;
-(id)getByIndex:(int)index;

@end
