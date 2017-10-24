//
//  ReferenceType.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 19/05/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import "Control.h"

typedef enum {
    ReferenceType_Ahref,
    /**
     * The IMG.
     */
    ReferenceType_Img,
    /**
     * The link.
     */
    ReferenceType_Link,
    /**
     * The script.
     */
    ReferenceType_Script,
    ReferenceType_Style
    
}ReferenceType;
