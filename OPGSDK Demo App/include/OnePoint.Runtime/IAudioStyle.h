//
//  IAudioStyle.h
//  PlayerTest
//
//  Created by Varahala Babu on 08/07/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioControlPositions.h"
#import "RecordModes.h"
@protocol IAudioStyle <NSObject>
- (NSString *)getName;
- (void)setName:(NSString *)value;
- (AudioControlPositions)getPlayControlPosition;
- (void)setPlayControlPosition:(AudioControlPositions)value;
- (RecordModes)getRecord;
- (void)setRecord:(RecordModes)value;
- (AudioControlPositions)getRecordControlPosition;
- (void)setRecordControlPosition:(AudioControlPositions)value;
- (BOOL)getIsEmpty;
@end
