//
//  SkeletonEnumerator.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 1/12/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import "ISkeletonCollection.h"
@interface SkeletonEnumerator : NSObject<ISkeletonCollection>{
     id<ISkeletonCollection> collection;
    int pointer;
    
}

-(id)getCollection;
-(void)setCollection:(id)value;
-(id)initWithISkeletonCollection:(id)aCollection;
-(NSNumber *)movenext;
@end
