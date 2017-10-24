//
//  DocType.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 19/05/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"

@interface DocType : Control
{
    NSString *__DocumentType;
}
-(NSString*) getDocumentType ;
-(void)setDocumentType:(NSString*) value ;
-(id)initWithIControl:(id<IControl>)parent;
@end
